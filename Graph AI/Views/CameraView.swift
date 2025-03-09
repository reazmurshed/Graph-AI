import SwiftUI
import SwiftData

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = CameraViewModel()
    @State private var showingConfirmation = false
    @State private var showingSubscriptionPromo = false
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isAnalyzing {
                    if let image = viewModel.capturedImage {
                        WaitingView(image: image, analysis: viewModel.analysis)
                    }
                } else if showingConfirmation, let image = viewModel.capturedImage {
                    // Confirmation Screen
                    ZStack {
                        Color(hex: "1A1A1A").ignoresSafeArea()
                        
                        VStack(spacing: 25) {
                            // Close button con padding fijo
                            HStack {
                                Button(action: {
                                    showingConfirmation = false
                                    viewModel.resetState()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.green)
                                        .frame(width: 44, height: 44)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)  // Padding fijo en lugar de safe area
                            
                            // Title
                            Text("Confirm Chart Photo")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.top, 5)
                            
                            // Image
                            Image(uiImage: image)
                                .chartImageStyle()
                                .padding(.top, 40)
                            
                            Spacer()
                            
                            // Buttons
                            VStack(spacing: 15) {
                                Button(action: {
                                    if subscriptionManager.trialStatus == .active {
                                        if let image = viewModel.capturedImage {
                                            showingConfirmation = false
                                            Task {
                                                await viewModel.analyzeImage(image)
                                            }
                                        }
                                    } else {
                                        showingSubscriptionPromo = true
                                    }
                                }) {
                                    Text("Analyze Chart")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(
                                            LinearGradient(
                                                colors: [.green, .green.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .cornerRadius(28)
                                        .shadow(color: .green.opacity(0.3), radius: 8, y: 4)
                                }
                                .padding(.horizontal)
                                
                                Button(action: {
                                    showingConfirmation = false
                                    viewModel.resetState()
                                }) {
                                    Text("Retake Photo")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            .padding(.bottom, 30)  // Añadido padding bottom para separar del borde
                        }
                    }
                } else {
                    // Camera preview
                    viewModel.cameraPreview
                        .ignoresSafeArea()
                    
                    if let analysis = viewModel.analysis {
                        // Navigate to analysis view and auto-save
                        NavigationLink(
                            destination: AnalysisResultView(
                                analysis: analysis,
                                image: viewModel.capturedImage ?? UIImage(),
                                onBack: { dismiss() }
                            ),
                            isActive: $viewModel.showingAnalysis
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    
                    // Camera controls
                    VStack {
                        Spacer()
                        
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button(action: { 
                                viewModel.captureImage()
                                showingConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 20))
                                    Text("Analyze Graph")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(.ultraThinMaterial)
                            }
                            
                            Spacer()
                            
                            Button(action: { viewModel.switchCamera() }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showingSubscriptionPromo) {
            PaywallView(hidePaywallIntro: $showingSubscriptionPromo)
            //SubscriptionPromoView()
        }
        .onChange(of: viewModel.analysis) { newAnalysis in
            if subscriptionManager.trialStatus == .active,
               let analysis = newAnalysis,
               let imageData = viewModel.capturedImage?.jpegData(compressionQuality: 0.8) {
                do {
                    let record = try AnalysisRecord(imageData: imageData, analysis: analysis)
                    modelContext.insert(record)
                } catch {
                    print("Error saving analysis: \(error)")
                }
            }
        }
        .onDisappear {
            viewModel.resetState()
        }
        .onChange(of: viewModel.errorMessage) { newError in
            if !newError.isEmpty {
                // Show error alert or banner
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}

struct RotatingShadowModifier: ViewModifier {
    @State private var rotations: [Double] = Array(repeating: 0, count: 6)
    
    func body(content: Content) -> some View {
        content
            // Sombra 1 - Verde claro
            .shadow(color: Color(hex: "90EE90").opacity(0.25), radius: 15, 
                   x: 15 * cos(rotations[0]), y: 15 * sin(rotations[0]))
            // Sombra 2 - Verde esmeralda
            .shadow(color: Color(hex: "50C878").opacity(0.25), radius: 15,
                   x: -12 * cos(rotations[1]), y: -12 * sin(rotations[1]))
            // Sombra 3 - Verde bosque
            .shadow(color: Color(hex: "228B22").opacity(0.25), radius: 15,
                   x: 13 * sin(rotations[2]), y: -13 * cos(rotations[2]))
            // Sombra 4 - Verde lima
            .shadow(color: Color(hex: "32CD32").opacity(0.25), radius: 15,
                   x: -11 * sin(rotations[3]), y: 11 * cos(rotations[3]))
            // Sombra 5 - Verde menta
            .shadow(color: Color(hex: "98FF98").opacity(0.25), radius: 15,
                   x: 10 * cos(rotations[4]), y: -10 * sin(rotations[4]))
            // Sombra 6 - Verde oliva
            .shadow(color: Color(hex: "6B8E23").opacity(0.25), radius: 15,
                   x: -14 * sin(rotations[5]), y: -14 * cos(rotations[5]))
            .onAppear {
                for i in 0..<6 {
                    withAnimation(
                        .linear(duration: Double.random(in: 6...10))
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...2))
                    ) {
                        rotations[i] = 2 * .pi
                    }
                }
            }
    }
}

struct BouncingModifier: ViewModifier {
    @State private var bouncing = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: bouncing ? -5 : 5)
            .animation(
                Animation
                    .easeInOut(duration: 2.5)
                    .repeatForever(autoreverses: true),
                value: bouncing
            )
            .onAppear {
                bouncing = true
            }
    }
}

#Preview {
    CameraView()
        .modelContainer(PreviewContainer([AnalysisRecord.self]).container)
} 
