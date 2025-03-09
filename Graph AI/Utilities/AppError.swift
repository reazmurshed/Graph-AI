import Foundation

// MARK: - Error Types
enum AppError {
    // MARK: - Camera Errors
    enum Camera: Error {
        case imageConversionFailed
        case imageCompression
        case accessDenied
        case setupFailed
    }
    
    // MARK: - API Errors
    enum API: Error {
        case invalidURL
        case invalidResponse
        case serverError(Int)
        case openAIError(String)
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL configuration"
            case .invalidResponse:
                return "Invalid response from server"
            case .serverError(let code):
                return "Server error with code: \(code)"
            case .openAIError(let message):
                return message
            }
        }
    }
} 