//
//  NoteCard.swift
//  nosub-notes
//
//  Created by Collin Dietz on 2/20/26.
//


import SwiftUI

struct NoteCard: View {
    var note: Note
    
    var body: some View {
        VStack {
            Spacer()
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