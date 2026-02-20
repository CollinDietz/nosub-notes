//
//  NoteView.swift
//  nosub-notes
//
//  Created by Collin Dietz on 2/20/26.
//


import SwiftUI
import SwiftData

struct NoteView: View {
    @Bindable var note: Note
    
    var body: some View {
        VStack {
            CanvasView(drawingData: $note.drawingData)
                .ignoresSafeArea()
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}