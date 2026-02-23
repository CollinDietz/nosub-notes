import SwiftUI
import SwiftData

struct NoteView: View {
    @Bindable var note: Note
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            CanvasView(drawingData: $note.drawingData)
                .ignoresSafeArea(.all)

            // Floating back button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 50)
            .padding(.leading, 20)
        }
        .navigationBarHidden(true)
    }
}
