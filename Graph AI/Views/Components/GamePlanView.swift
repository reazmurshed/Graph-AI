import SwiftUI

struct GamePlanView: View {
    let analysis: GraphAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Game Plan")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(analysis.gamePlan ?? "Analyzing market conditions...")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.3))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
} 