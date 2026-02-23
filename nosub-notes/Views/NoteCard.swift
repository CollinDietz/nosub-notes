//
//  NoteCard.swift
//  nosub-notes
//
//  Created by Collin Dietz on 2/20/26.
//


import SwiftUI
import PencilKit

struct NoteCard: View {
    var note: Note

    private func drawingThumbnail(from data: Data) -> UIImage? {
        guard let drawing = try? PKDrawing(data: data) else { return nil }
        let bounds = drawing.bounds.isEmpty ? CGRect(x: 0, y: 0, width: 100, height: 100) : drawing.bounds

        // Force light mode trait collection
        let lightTraitCollection = UITraitCollection(userInterfaceStyle: .light)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0

        var imageResult: UIImage!
        lightTraitCollection.performAsCurrent {
            let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
            imageResult = renderer.image { context in
                UIColor.white.setFill()
                context.fill(bounds)
                drawing.image(from: bounds, scale: 1.0).draw(in: bounds)
            }
        }
        return imageResult
    }

    var body: some View {
        VStack {
            // Try to get thumbnail from first page, fallback to legacy drawingData
            let thumbnailData = note.pages.first?.drawingData ?? note.drawingData

            if let data = thumbnailData,
               let image = drawingThumbnail(from: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 160)
            }
            Text(note.title)
                .font(.headline)
                .padding()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}
