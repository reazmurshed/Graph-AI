import SwiftUI
import SwiftData
import AVFoundation

// MARK: - CameraViewModel
@MainActor
class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    enum State {
        case camera
        case processing
        case preview(UIImage)
        case result(GraphAnalysis, UIImage)
        case error(String)
    }
    
    // MARK: - Error Types
    enum CameraError: LocalizedError {
        case cameraUnavailable
        case imageCaptureFailed
        case imageCompressionFailed
        case apiError(String)
        case savingError
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .cameraUnavailable:
                return "Camera is not available"
            case .imageCaptureFailed:
                return "Failed to capture image"
            case .imageCompressionFailed:
                return "Failed to compress image"
            case .apiError(let message):
                return message
            case .savingError:
                return "Failed to save analysis"
            case .unknown:
                return "An unknown error occurred"
            }
        }
    }
    
    // MARK: - Properties
    @Published var currentState: State = .camera
    @Published var capturedImage: UIImage?
    @Published var analysis: GraphAnalysis?
    @Published var showingAnalysis = false
    @Published var error: Error?
    @Published var errorMessage = ""
    @Published var isAnalyzing = false
    @Published private(set) var isSessionReady = false
    
    private let captureSession = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    
    private let apiClient: APIClientProtocol
    private let imageProcessor = ImageProcessor()
    private let analysisQueue = DispatchQueue(label: "com.graphai.analysis", qos: .userInitiated)
    
    // MARK: - Initialization
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            self.errorMessage = CameraError.cameraUnavailable.localizedDescription
            return
        }
        
        let output = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        self.photoOutput = output
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    var cameraPreview: some View {
        CameraPreviewView(session: captureSession)
            .ignoresSafeArea()
    }
    
    // MARK: - Public Methods
    func captureImage() {
        guard let photoOutput = photoOutput else {
            errorMessage = CameraError.cameraUnavailable.localizedDescription
            return
        }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            errorMessage = CameraError.imageCaptureFailed.localizedDescription
            return
        }
        
        Task { @MainActor in
            self.capturedImage = image
        }
    }
    
    func switchCamera() {
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else {
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(currentInput)
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newCamera) else {
            return
        }
        
        if captureSession.canAddInput(newInput) {
            captureSession.addInput(newInput)
        }
        
        captureSession.commitConfiguration()
    }
    
    func analyzeImage(_ image: UIImage) async {
        isAnalyzing = true
        do {
            guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                throw CameraError.imageCompressionFailed
            }
            
            analysis = try await apiClient.analyzeGraph(imageData)
            showingAnalysis = true
        } catch {
            if let cameraError = error as? CameraError {
                errorMessage = cameraError.localizedDescription
            } else {
                errorMessage = CameraError.apiError(error.localizedDescription).localizedDescription
            }
        }
        isAnalyzing = false
    }
    
    func resetState() {
        capturedImage = nil
        analysis = nil
        showingAnalysis = false
        error = nil
        errorMessage = ""
        currentState = .camera
    }
}

// MARK: - Camera Preview View
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.previewLayer.frame = uiView.bounds
    }
}

// Add a new ImageProcessor class
actor ImageProcessor {
    func prepareImageForAnalysis(_ image: UIImage) async -> UIImage {
        // Resize image if too large
        let maxDimension: CGFloat = 1200
        let size = image.size
        
        if size.width > maxDimension || size.height > maxDimension {
            let ratio = size.width / size.height
            let newSize: CGSize
            
            if size.width > size.height {
                newSize = CGSize(width: maxDimension, height: maxDimension / ratio)
            } else {
                newSize = CGSize(width: maxDimension * ratio, height: maxDimension)
            }
            
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            
            let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
            return renderer.image { context in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
        
        return image
    }
} 