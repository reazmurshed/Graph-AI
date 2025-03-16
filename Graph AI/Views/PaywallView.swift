//
//  PaywallView.swift
//  Graph AI
//
//  Created by Reaz Sumon on 7/3/25.
//

import SwiftUI
import AVKit
import RevenueCat

struct PaywallView: View {
    @State private var isYearlyChoosed = true
    @State private var playingVideo = true
    @Environment(\.dismiss) private var dismiss
    
    var player: AVPlayer {
        if let url = Bundle.main.url(forResource: "ORIGINAL", withExtension: "mp4") {
            let player = AVPlayer(url: url)
            player.actionAtItemEnd = .none
            
            // Looping logic: Observe when the video finishes and restart
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                //playingVideo = false
                player.seek(to: .zero)
                player.play()
            }
            print("found video URL")
            player.play()
            return player
        } else {
            print("Can't find video URL")
        }
        
        return AVPlayer()
    }
    
    var body: some View {
        VStack {
            // Header View Section
            if playingVideo {
                Text("Start trading like an expert with Graph Al.")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Permium Features Section
                VStack(alignment: .leading, spacing: 16) {
                    VideoPlayerView(player: player)
                        .onAppear {
                            player.play()
                        }
                        .onDisappear {
                            player.pause()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                }
                .padding(.top, 5)
                .padding(.bottom, 5)
            } else {
                // Custom Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .background(.clear)
                        .cornerRadius(8)
                    }
                    Spacer() // Pushes button to the left
                }
                .padding()
                
                // Header View Section
                Text("Unlock Graph AI to turn charts into cash.")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Permium Features Section
                VStack(alignment: .leading, spacing: 16) {
                    CustomCell(text: "No More Gambling", description: "Understand market trends with precise insights from your chart.")
                    CustomCell(text: "Custom Trading Strategy", description: "Get a step-by-step game plan to make your next winning trade.")
                    CustomCell(text: "Trade With Confidence", description: "AI-powered analysis to boost your trading confidence and clarity.")
                }
                .padding(.top, 5)
                
                Spacer()
                
                // Subscription Pack Section
                VStack {
                    HStack {
                        ForEach(PaywallHelper.shared.allPackages ?? []) { package in
                            
                            if let subscriptionPeriod = package.storeProduct.subscriptionPeriod {
                                
                                if subscriptionPeriod.unit == .month && subscriptionPeriod.value == 1 {
                                    
                                    SubscriptionOptionView(title: "Monthly", price: getFormattedPrice(package: package), isSelected: !isYearlyChoosed, showFreeTrial: false)
                                        .onTapGesture {
                                            isYearlyChoosed = false
                                            PaywallHelper.shared.selectedPackage = package
                                        }
                                } else if subscriptionPeriod.unit == .year {
                                    
                                    SubscriptionOptionView(title: "Yearly", price: getFormattedPrice(package: package), isSelected: isYearlyChoosed, showFreeTrial: hasFreeTrial())
                                        .onTapGesture {
                                            isYearlyChoosed = true
                                            PaywallHelper.shared.selectedPackage = package
                                        }
                                }
                            }
                        }
                    }
                    .padding(.top, 24)
                }
            }
            
            // Bottom Section
            VStack {
                Text("✓ No Commitment - Cancel Anytime")
                    .font(Font.system(size: 15))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                Button(action: {
                    if playingVideo {
                        playingVideo = false
                        print("Subscription Continue...")
                    } else {
                        print("Start Subscription...")
                        if let package = PaywallHelper.shared.selectedPackage {
                            print("Navigate to Payment Screen...")
                            PaywallHelper.shared.purchase(package: package) { success in
                                if success {
                                    print("Purchase Success...")
                                    SubscriptionManager.shared.isSubscribed = success
                                    dismiss()
                                } else {
                                    print("Failed to Purchase...")
                                }
                            }
                        }
                    }
                }) {
                    Text(getButtonTitle())
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .padding(.horizontal, 12)
                }
                .frame(maxHeight: 44)
                .padding(.top, 16)
                
                // Pack Price Section
                if let package = PaywallHelper.shared.selectedPackage {
                    Text(getFullFormFormattedPrice(package: package))
                        .padding(.top, 4)
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Text("Just 34,99 € per year (2,91 €/mo)")
                        .padding(.top, 4)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                
                // Footer Section
                HStack(spacing: 16) {
                    Link("Terms of Service", destination: URL(string: "https://example.com")!)
                        .foregroundColor(.gray)
                    Link("Privacy Policy", destination: URL(string: "https://example.com")!)
                        .foregroundColor(.gray)
                    Button("Restore Purchase") {
                        print("Restore Purchase Tapped")
                        PaywallHelper.shared.restorePurchases { success in
                            if success {
                                SubscriptionManager.shared.isSubscribed = success
                                dismiss()
                                print("Restore Purchases Success")
                            } else {
                                print("Restore Purchases Failed")
                            }
                        }
                    }
                    .padding(.top, 4)
                    .foregroundColor(.gray)
                }
                .font(.footnote)
            }
        }
        .padding(.top, 12)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    func getButtonTitle() -> String {
        guard !playingVideo else {
            return "Continue"
        }
        guard PaywallHelper.shared.selectedPackage != nil else {
            return playingVideo ? "Continue" : "Unlock"
        }
        if hasFreeTrial() {
            return "Start My Free Trial"
        } else {
            return playingVideo ? "Continue" : "Unlock"
        }
    }
    
    func hasFreeTrial() -> Bool {
        guard let package = PaywallHelper.shared.selectedPackage else {
            return false
        }
        if let introOffer = package.storeProduct.introductoryDiscount {
            return introOffer.paymentMode == .freeTrial
        }
        return false
    }
    
    func getFormattedPrice(package: Package) -> String {
        var monthlyPrice: Float = (package.storeProduct.price as NSDecimalNumber).floatValue
        if let subscriptionPeriod = package.storeProduct.subscriptionPeriod {
            if subscriptionPeriod.unit == .year {
                monthlyPrice = monthlyPrice / 12.0
            }
        }
        if let currencyCode = package.storeProduct.currencyCode {
            return "\(String(format: "%.2f", monthlyPrice))" + " " + getSymbol(forCurrencyCode: currencyCode) + " / mo"
        } else {
            return "\(monthlyPrice)" + " " + "$" + " / mo"
        }
    }
    
    func getFullFormFormattedPrice(package: Package) -> String {
        var monthlyPrice: Float = (package.storeProduct.price as NSDecimalNumber).floatValue
        var currencyCode: String = getSymbol(forCurrencyCode: "USD")
        if let currency = package.storeProduct.currencyCode {
            currencyCode = getSymbol(forCurrencyCode: currency)
        }
        
        if let subscriptionPeriod = package.storeProduct.subscriptionPeriod {
            if subscriptionPeriod.unit == .year {
                monthlyPrice = monthlyPrice / 12.0
                return "Just " + "\(String(format: "%.2f", monthlyPrice * 12))" + " " + currencyCode + " per year" + " (" + "\(String(format: "%.2f", monthlyPrice))" + " " + currencyCode + "/mo" + ")"
            } else {
                return "Just " + "\(String(format: "%.2f", monthlyPrice))" + " " + currencyCode + " per month"
            }
        } else {
            return "Just " + "\(String(format: "%.2f", monthlyPrice))" + " " + currencyCode + " per month"
        }
    }
    
    func getSymbol(forCurrencyCode code: String) -> String {
       let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? code
    }
}



struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        playerLayer.contentsGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        // Update player layer on layout changes
        DispatchQueue.main.async {
            playerLayer.frame = view.bounds
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
        }
    }
}

// Custom Cell
struct CustomCell: View {
    let text: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .font(.title3)
                        .frame(width: 20)
                    Text(text)
                        .font(.headline)
                        .padding(.bottom, 2)
                }
                Text(description)
                    .padding(.horizontal, 28)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 10)
    }
}

struct SubscriptionOptionView: View {
    let title: String
    let price: String
    let isSelected: Bool
    let showFreeTrial: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            // Subscription Box
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.white : Color.gray, lineWidth: 6)
                .background(Color.clear)
                .cornerRadius(12)
                .frame(maxWidth: .infinity, maxHeight: 100)

            // "3 DAYS FREE" Badge
            if showFreeTrial {
                Text(" 3 DAYS FREE ")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .foregroundColor(.black)
                    .offset(y: -12)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 4)

                    Text(price)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.horizontal, 12)
    }
}

// Subscription Pack View
struct SubscriptionPack: View {
    let title: String
    let price: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                    Text(price)
                        .font(.headline)
                }
                .padding()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(Color.clear)
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.white : Color.gray, lineWidth: 4))
            .cornerRadius(12)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
    }
}


struct PaywallIntoView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
            .previewDevice("iPhone 14 Pro Max")
    }
}
