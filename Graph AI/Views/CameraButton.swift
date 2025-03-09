import SwiftUI

struct CameraButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(Constants.Animation.buttonScale) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action()
            }
        }) {
            Image(systemName: "camera.fill")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
                .background(Constants.accentColor)
                .clipShape(Circle())
                .shadow(color: Constants.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
    }
}

#Preview {
    ZStack {
        Color(hex: "1A1A1A")
        CameraButton(action: {})
    }
} 