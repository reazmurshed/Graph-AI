import SwiftUI

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection = -1
    
    let sections = [
        LegalSection(
            title: "1. Acceptance of Terms",
            content: [
                "1.1 By accessing and using Graph AI, you agree to be bound by these Terms and Conditions.",
                "1.2 If you do not agree with any part of these terms, please do not use the application.",
                "1.3 We reserve the right to modify these terms at any time without prior notice."
            ]
        ),
        LegalSection(
            title: "2. Service Description",
            content: [
                "2.1 Graph AI is a chart analysis tool that provides AI-powered insights and analysis.",
                "2.2 The application is intended for educational and informational purposes only.",
                "2.3 We do not guarantee the accuracy, completeness, or usefulness of any analysis.",
                "2.4 The service may be modified, suspended, or discontinued at any time."
            ]
        ),
        LegalSection(
            title: "3. User Responsibilities",
            content: [
                "3.1 You must be at least 18 years old to use this application.",
                "3.2 You are responsible for maintaining the confidentiality of your account.",
                "3.3 You agree not to use the service for any illegal or unauthorized purpose.",
                "3.4 You must not transmit any viruses, malware, or other malicious code.",
                "3.5 You are responsible for all activities that occur under your account."
            ]
        ),
        LegalSection(
            title: "4. Disclaimer",
            content: [
                "4.1 Graph AI is not a financial advisor or investment advisor.",
                "4.2 The analysis provided should not be considered as financial advice.",
                "4.3 Trading involves risk, and you should trade responsibly.",
                "4.4 Past performance does not guarantee future results.",
                "4.5 The application's analysis is based on historical data and AI algorithms, which may not accurately predict future market movements.",
                "4.6 We are not responsible for any financial losses incurred from using our service.",
                "4.7 The information provided is for educational purposes only and should not be used as the sole basis for making investment decisions.",
                "4.8 Users should conduct their own research and consult with financial professionals before making investment decisions."
            ]
        ),
        LegalSection(
            title: "5. Intellectual Property",
            content: [
                "5.1 All content, features, and functionality of Graph AI are owned by us.",
                "5.2 The application's name, logo, and all related names are our trademarks.",
                "5.3 You may not copy, modify, or distribute any part of the application without our permission.",
                "5.4 The AI algorithms and analysis methods are proprietary and confidential."
            ]
        ),
        LegalSection(
            title: "6. Limitation of Liability",
            content: [
                "6.1 We shall not be liable for any indirect, incidental, special, consequential, or punitive damages.",
                "6.2 We are not responsible for any loss of data, profits, or business opportunities.",
                "6.3 Our liability is limited to the amount paid for the service, if any.",
                "6.4 We are not liable for any third-party actions or content."
            ]
        ),
        LegalSection(
            title: "7. Subscription and Payments",
            content: [
                "7.1 Subscription fees are billed in advance on a monthly or annual basis.",
                "7.2 All payments are non-refundable unless required by law.",
                "7.3 We reserve the right to change subscription fees with notice.",
                "7.4 You are responsible for any applicable taxes.",
                "7.5 Subscription auto-renews unless cancelled before the renewal date."
            ]
        ),
        LegalSection(
            title: "8. Termination",
            content: [
                "8.1 We may terminate or suspend your account at any time.",
                "8.2 You may terminate your account at any time.",
                "8.3 Upon termination, your right to use the service will immediately cease.",
                "8.4 We may retain your data as required by law or for legitimate business purposes."
            ]
        ),
        LegalSection(
            title: "9. Governing Law",
            content: [
                "9.1 These terms shall be governed by the laws of the United States.",
                "9.2 Any disputes shall be resolved in the courts of the United States.",
                "9.3 The application is intended for use in jurisdictions where it is legal to do so."
            ]
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(sections.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: {
                            withAnimation {
                                if selectedSection == index {
                                    selectedSection = -1
                                } else {
                                    selectedSection = index
                                }
                            }
                        }) {
                            HStack {
                                Text(sections[index].title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .rotationEffect(.degrees(selectedSection == index ? 90 : 0))
                            }
                        }
                        
                        if selectedSection == index {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(sections[index].content, id: \.self) { item in
                                    Text(item)
                                        .foregroundColor(.gray)
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.3))
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct LegalSection {
    let title: String
    let content: [String]
} 