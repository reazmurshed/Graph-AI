import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CameraViewModel()
    @State private var showingCamera = false
    @State private var showingMenu = false
    @State private var buttonScale: CGFloat = 1.0
    @StateObject private var backgroundManager = BackgroundManager.shared
    @State private var showingSubscriptionPromo = false
    @State private var showingOnboardingScreen = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // Layer 1: Background
                    AsyncImage(url: URL(string: backgroundManager.selectedBackground.rawValue)) { image in
                        GeometryReader { geo in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: geo.size.width * 1.3,
                                    height: geo.size.height * 1.3
                                )
                                .position(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2
                                )
                                .clipped()
                                .edgesIgnoringSafeArea(.all)
                        }
                    } placeholder: {
                        Color(hex: "1A1A1A")
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    // Layer 2: Main Content
                    VStack(spacing: 0) {
                        // Top Bar
                        HStack {
                            Button(action: { showingMenu = true }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(12)
                            }
                            
                            Spacer()
                            
                            Text("Graph AI")
                                .font(.system(size: 41, weight: .bold))
                                .italic()
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 5)
                            
                            Spacer()
                            
                            NavigationLink(destination: HistoryView()) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, UIScreen.main.bounds.height * 0.1)
                        .ignoresSafeArea(.all, edges: .top)
                        
                        Spacer()
                        
                        // Bottom Button with animation
                        VStack(spacing: 8) {
                            Button(action: { showingCamera = true }) {
                                HStack(spacing: 20) {
                                    Text("💰")
                                        .font(.system(size: 72))
                                        .offset(y: buttonScale * 5)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Upload a Chart")
                                            .font(.system(size: 28, weight: .bold))
                                        
                                        Text("Get Money-Making Insights")
                                            .font(.system(size: 16))
                                            .opacity(0.8)
                                    }
                                    
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 32)
                                .padding(.horizontal, 32)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(16)
                                .scaleEffect(buttonScale)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView()
                    .interactiveDismissDisabled(true)
            }
//            .fullScreenCover(isPresented: $showingCamera) {
//                OnboardingView(shouldShowView: $showingCamera)
//            }
            .sheet(isPresented: $showingMenu) {
                MenuView()
                    .presentationDetents([.medium])
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            showingOnboardingScreen = !UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.alreadyOnboarded)
        }
        .fullScreenCover(isPresented: $showingOnboardingScreen) {
            OnboardingView(shouldShowView: $showingOnboardingScreen, showingSubscriptionPromo: false)
        }
        .onAppear {
            PaywallHelper.shared.checkSubscriptionStatus { subscribed in
                subscriptionManager.isSubscribed = subscribed
                showingSubscriptionPromo = !subscribed
            }
        }
        .fullScreenCover(isPresented: $showingSubscriptionPromo) {
            PaywallView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SubscriptionManager.preview)
        .modelContainer(PreviewContainer([AnalysisRecord.self]).container)
}

// Extension to detect notch
extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let safeAreaTop = window?.safeAreaInsets.top ?? 0
        return safeAreaTop > 20
    }
} 
