import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawingData: Data?

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.backgroundColor = .white
        canvas.overrideUserInterfaceStyle = .light
        canvas.isUserInteractionEnabled = true
        canvas.drawingPolicy = .pencilOnly // works for Pencil & touch

        // Load saved drawing if available
        if let data = drawingData, let drawing = try? PKDrawing(data: data) {
            canvas.drawing = drawing
        }

        // Attach PKToolPicker for Pencil
        if UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first != nil {

            let toolPicker = PKToolPicker()
            toolPicker.overrideUserInterfaceStyle = .light
            context.coordinator.toolPicker = toolPicker
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView
        private var saveWorkItem: DispatchWorkItem?
        var toolPicker: PKToolPicker?

        init(_ parent: CanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Debounce saving to reduce system warnings
            saveWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                self?.parent.drawingData = canvasView.drawing.dataRepresentation()
            }
            saveWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
        }
    }
}
