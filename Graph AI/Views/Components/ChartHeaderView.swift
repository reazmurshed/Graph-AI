import SwiftUI

struct ChartHeaderView: View {
    let imageData: Data?
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            // Efectos neón
            ForEach(0..<3) { i in
                if let image = imageData.flatMap(UIImage.init) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: CGFloat(i * 5))
                        .opacity(isGlowing ? 0.3 : 0.1)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever()
                                .delay(Double(i) * 0.5),
                            value: isGlowing
                        )
                }
            }
            
            // Imagen principal
            if let image = imageData.flatMap(UIImage.init) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .onAppear {
            withAnimation {
                isGlowing = true
            }
        }
    }
} 