import SwiftUI

struct LevelSection: View {
    let title: String
    let levels: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ForEach(levels, id: \.self) { level in
                Text(level)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
        }
    }
} 