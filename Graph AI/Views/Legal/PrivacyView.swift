import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection = -1
    
    let sections = [
        LegalSection(
            title: "1. Information We Collect",
            content: [
                "1.1 Personal Information:",
                "• Account information (email, name)",
                "• Payment information (processed securely through App Store)",
                "• Usage data and analytics",
                "1.2 Chart Data:",
                "• Images of charts you upload for analysis",
                "• Analysis results and history",
                "1.3 Device Information:",
                "• Device type and model",
                "• Operating system version",
                "• App version",
                "• Unique device identifiers"
            ]
        ),
        LegalSection(
            title: "2. How We Use Your Information",
            content: [
                "2.1 Primary Uses:",
                "• To provide and improve our chart analysis service",
                "• To process your payments and manage subscriptions",
                "• To send you important updates about the service",
                "2.2 Analysis and Improvement:",
                "• To improve our AI algorithms and analysis accuracy",
                "• To understand how users interact with our app",
                "• To identify and fix technical issues",
                "2.3 Communication:",
                "• To respond to your support requests",
                "• To send you service updates and notifications",
                "• To provide customer support"
            ]
        ),
        LegalSection(
            title: "3. Data Storage and Security",
            content: [
                "3.1 Storage:",
                "• Your data is stored securely on cloud servers",
                "• We use industry-standard encryption for data transmission",
                "• Chart images are stored temporarily for analysis",
                "3.2 Security Measures:",
                "• Regular security audits and updates",
                "• Access controls and authentication",
                "• Data encryption at rest and in transit",
                "3.3 Data Retention:",
                "• Analysis history is retained for 7 days",
                "• Account data is retained as long as your account is active",
                "• You can request data deletion at any time"
            ]
        ),
        LegalSection(
            title: "4. Data Sharing and Disclosure",
            content: [
                "4.1 We do not sell your personal information",
                "4.2 We may share data with:",
                "• Service providers who assist in app operation",
                "• Analytics providers to improve our service",
                "• Law enforcement when required by law",
                "4.3 Third-Party Services:",
                "• App Store for payment processing",
                "• Cloud storage providers",
                "• Analytics services"
            ]
        ),
        LegalSection(
            title: "5. Your Rights and Choices",
            content: [
                "5.1 Access Rights:",
                "• View your personal information",
                "• Request data correction",
                "• Export your data",
                "5.2 Control Options:",
                "• Opt-out of analytics",
                "• Manage notification preferences",
                "• Delete your account",
                "5.3 Data Portability:",
                "• Request your data in a readable format",
                "• Transfer your data to another service"
            ]
        ),
        LegalSection(
            title: "6. Children's Privacy",
            content: [
                "6.1 Our service is not intended for children under 13",
                "6.2 We do not knowingly collect data from children",
                "6.3 Parents can contact us to remove children's data",
                "6.4 We comply with COPPA and other child privacy laws"
            ]
        ),
        LegalSection(
            title: "7. International Data Transfers",
            content: [
                "7.1 Data may be transferred internationally",
                "7.2 We comply with international data protection laws",
                "7.3 We use standard contractual clauses for transfers",
                "7.4 We maintain appropriate safeguards for cross-border transfers"
            ]
        ),
        LegalSection(
            title: "8. Changes to Privacy Policy",
            content: [
                "8.1 We may update this policy periodically",
                "8.2 Users will be notified of significant changes",
                "8.3 Continued use implies acceptance of changes",
                "8.4 Previous versions are available upon request"
            ]
        ),
        LegalSection(
            title: "9. Contact Us",
            content: [
                "9.1 For privacy-related questions:",
                "Email: privacy@graphai.app",
                "9.2 For data requests:",
                "Email: data@graphai.app",
                "9.3 Response time:",
                "We aim to respond within 30 days"
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
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(hex: "1A1A1A").ignoresSafeArea())
        .navigationTitle("Privacy Policy")
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

#Preview {
    PrivacyView()
        .preferredColorScheme(.dark)
} 