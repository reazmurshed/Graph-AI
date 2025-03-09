import SwiftUI

struct ConditionSection: View {
    let title: String
    let conditions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ForEach(conditions, id: \.self) { condition in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    
                    Text(condition)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
} 