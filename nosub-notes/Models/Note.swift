//
//  Note.swift
//  nosub-notes
//
//  Created by Collin Dietz on 2/20/26.
//


import SwiftData
import Foundation

@Model
class Note {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var drawingData: Data? // Keep for backward compatibility
    var pages: [NotePage]

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.updatedAt = Date()
        self.pages = []

        // Create first page by default
        let firstPage = NotePage(pageNumber: 0)
        self.pages.append(firstPage)
    }
}
