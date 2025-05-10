//
//  PaymentConfirmationView.swift
//  Graph AI
//
//  Created by Reaz Sumon on 22/3/25.
//

import SwiftUI

struct PaymentConfirmationView: View {
    var isSuccess: Bool
    var message: String
    var onDismiss: () -> Void // Closure to handle dismissal
    
    var body: some View {
        ZStack {
            // Blurred Background
            Color.white.edgesIgnoringSafeArea(.all).opacity(0.3)
            
            VStack(spacing: 20) {
                // Success or Failure Icon
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(isSuccess ? .green : .red)
                    .shadow(radius: 5)
                
                // Success or Failure Message
                Text(message)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // "Done" Button
                Button(action: onDismiss) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSuccess ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            }
            .padding()
            .frame(maxWidth: 300, minHeight: 300)
            .background(.white) // Blurred card background
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

struct PaymentContentView: View {
    @State private var showConfirmation = false
    @State private var isSuccess = false

    var body: some View {
        VStack {
            Button("Simulate Payment") {
                isSuccess.toggle()
                showConfirmation = true
            }
        }
        .sheet(isPresented: $showConfirmation) {
            PaymentConfirmationView(
                isSuccess: isSuccess,
                message: isSuccess ? "Thank you for subscribing!" : "Payment Failed. Please try again.",
                onDismiss: { showConfirmation = false }
            )
            .background(Color.clear) // Ensures full transparency
            .zIndex(1) // Keep on top
            .animation(.easeInOut, value: showConfirmation)
        }
    }
}

#Preview {
    PaymentContentView()
}
