import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var drawingData: Data?

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        scrollView.backgroundColor = UIColor.systemGray5
        scrollView.bounces = true
        scrollView.bouncesZoom = true

        // Get screen size from window scene
        let screenSize: CGSize
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {
            screenSize = windowScene.screen.bounds.size
        } else {
            screenSize = CGSize(width: 1000, height: 1000) // fallback
        }

        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.backgroundColor = .white
        canvas.overrideUserInterfaceStyle = .light
        canvas.isUserInteractionEnabled = true
        canvas.drawingPolicy = .pencilOnly
        canvas.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 0.1
        canvas.layer.shadowOffset = CGSize(width: 0, height: 2)
        canvas.layer.shadowRadius = 8

        // Load saved drawing if available
        if let data = drawingData, let drawing = try? PKDrawing(data: data) {
            canvas.drawing = drawing
        }

        scrollView.addSubview(canvas)
        scrollView.contentSize = canvas.frame.size
        scrollView.zoomScale = 1.0
        scrollView.contentInsetAdjustmentBehavior = .never
        context.coordinator.canvas = canvas
        context.coordinator.scrollView = scrollView

        // Attach PKToolPicker for Pencil
        if UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first != nil {

            let toolPicker = PKToolPicker()
            toolPicker.overrideUserInterfaceStyle = .light
            context.coordinator.toolPicker = toolPicker
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate, UIScrollViewDelegate {
        var parent: CanvasView
        private var saveWorkItem: DispatchWorkItem?
        var toolPicker: PKToolPicker?
        var canvas: PKCanvasView?
        var scrollView: UIScrollView?

        init(_ parent: CanvasView) {
            self.parent = parent
        }

        func centerCanvas() {
            guard let scrollView = scrollView, let canvas = canvas else { return }

            // Only center when zoomed out, not at default scale
            if scrollView.zoomScale < 1.0 {
                let offsetX = max((scrollView.bounds.width - canvas.frame.width * scrollView.zoomScale) / 2, 0)
                let offsetY = max((scrollView.bounds.height - canvas.frame.height * scrollView.zoomScale) / 2, 0)

                scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
            } else {
                scrollView.contentInset = .zero
            }
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

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return canvas
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            centerCanvas()
        }

        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            centerCanvas()
        }
    }
}
