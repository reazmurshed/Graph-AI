import SwiftUI

struct TechnicalAnalysisButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 20))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
            }
            .padding(.vertical, 21)
            .padding(.horizontal, 21)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.6))
            .cornerRadius(14)
        }
    }
} 