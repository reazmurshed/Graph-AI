import SwiftUI
import UIKit

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @StateObject private var backgroundManager = BackgroundManager.shared
    @StateObject private var languageManager = LanguageManager.shared
    @State private var isBackgroundExpanded = false
    @State private var isLanguageExpanded = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    menuHeader
                    menuContent
                }
            }
            .background(Color(hex: "1A1A1A").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private var menuHeader: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Text("Graph AI")
                .font(.system(size: 28, weight: .bold))
                .italic()
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, UIScreen.main.bounds.height * 0.02)
    }
    
    private var menuContent: some View {
        VStack(spacing: 20) {
            linksSection
            appearanceSection
            appOptionsSection
            legalSection
        }
        .padding(.horizontal)
    }
    
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appearance")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            languageGroup
            backgroundGroup
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
    
    private var linksSection: some View {
        VStack(spacing: 15) {
            menuLink(title: "Website", icon: "globe", url: "https://graphai.app")
            menuLink(title: "Instagram", icon: "camera", url: "https://instagram.com/graphai.app")
            menuLink(title: "X (Twitter)", icon: "message", url: "https://x.com/GraphAI_X")
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
    
    private var appOptionsSection: some View {
        VStack(spacing: 15) {
            Button(action: {
                if let url = URL(string: "mailto:support@graphai.app") {
                    UIApplication.shared.open(url)
                }
            }) {
                menuRow(title: "Support", icon: "envelope")
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
    
    private var legalSection: some View {
        VStack(spacing: 15) {
            NavigationLink(destination: TermsView()) {
                menuRow(title: "Terms & Conditions", icon: "doc.text")
            }
            
            NavigationLink(destination: PrivacyView()) {
                menuRow(title: "Privacy Policy", icon: "hand.raised")
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
    
    private var languageGroup: some View {
        VStack {
            Button(action: { isLanguageExpanded.toggle() }) {
                HStack {
                    menuRow(title: "Language", icon: "globe")
                    Spacer()
                    Image(systemName: isLanguageExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.green)
                }
            }
            
            if isLanguageExpanded {
                VStack(spacing: 8) {
                    ForEach(LanguageManager.Languages.allCases, id: \.self) { language in
                        Button(action: {
                            languageManager.selectedLanguage = language
                            showLanguageNotification()
                        }) {
                            HStack {
                                Text(language.displayName)
                                    .foregroundColor(.white)
                                Spacer()
                                if languageManager.selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    private var backgroundGroup: some View {
        VStack {
            Button(action: { isBackgroundExpanded.toggle() }) {
                HStack {
                    menuRow(title: "Background", icon: "photo")
                    Spacer()
                    Image(systemName: isBackgroundExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.green)
                }
            }
            
            if isBackgroundExpanded {
                VStack(spacing: 8) {
                    ForEach(BackgroundManager.Backgrounds.allCases, id: \.self) { background in
                        Button(action: {
                            withAnimation {
                                backgroundManager.selectedBackground = background
                            }
                        }) {
                            HStack {
                                backgroundManager.backgroundView(for: background.rawValue)
                                    .frame(height: 60)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                backgroundManager.selectedBackground == background ? 
                                                Color.green : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                
                                Text(background.displayName)
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    private func menuRow(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 24)
                .foregroundColor(.green)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    private func menuLink(title: String, icon: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            menuRow(title: title, icon: icon)
        }
    }
    
    private func showLanguageNotification() {
        Task { @MainActor in
            let banner = UIView()
            banner.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
            banner.layer.cornerRadius = 15
            banner.clipsToBounds = true
            
            let label = UILabel()
            label.text = "Language change will only affect analysis responses"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 0
            
            banner.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: banner.topAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -16)
            ])
            
            guard let window = UIApplication.shared.windows.first else { return }
            window.addSubview(banner)
            
            banner.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                banner.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                banner.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
                banner.widthAnchor.constraint(lessThanOrEqualTo: window.widthAnchor, constant: -32)
            ])
            
            banner.transform = CGAffineTransform(translationX: 0, y: -100)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                banner.transform = .identity
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3) {
                    banner.transform = CGAffineTransform(translationX: 0, y: -100)
                    banner.alpha = 0
                } completion: { _ in
                    banner.removeFromSuperview()
                }
            }
        }
    }
} 