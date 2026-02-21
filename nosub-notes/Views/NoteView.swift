import SwiftUI
import SwiftData

struct NoteView: View {
    @Bindable var note: Note

    var body: some View {
        CanvasView(drawingData: $note.drawingData)
            .ignoresSafeArea(.all)
            .navigationTitle(note.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
