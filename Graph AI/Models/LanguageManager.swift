import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var selectedLanguage: Languages {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    enum Languages: String, CaseIterable {
        case english = "en"
        case spanish = "es"
        case french = "fr"
        case german = "de"
        case italian = "it"
        case portuguese = "pt"
        case russian = "ru"
        case japanese = "ja"
        case korean = "ko"
        case chinese = "zh"
        
        var displayName: String {
            switch self {
            case .english: return "🇺🇸 English"
            case .spanish: return "🇪🇸 Español"
            case .french: return "🇫🇷 Français"
            case .german: return "🇩🇪 Deutsch"
            case .italian: return "🇮🇹 Italiano"
            case .portuguese: return "🇵🇹 Português"
            case .russian: return "🇷🇺 Русский"
            case .japanese: return "🇯🇵 日本語"
            case .korean: return "🇰🇷 한국어"
            case .chinese: return "🇨🇳 中文"
            }
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Languages.allCases.first(where: { $0.rawValue == savedLanguage }) {
            self.selectedLanguage = language
        } else {
            self.selectedLanguage = .english
        }
    }
} 