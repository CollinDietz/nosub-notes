//
//  NotePage.swift
//  nosub-notes
//
//  Created by Collin Dietz on 2/23/26.
//

import SwiftData
import Foundation

@Model
class NotePage {
    var id: UUID
    var pageNumber: Int
    var drawingData: Data?
    var note: Note?

    init(pageNumber: Int) {
        self.id = UUID()
        self.pageNumber = pageNumber
        self.drawingData = nil
    }
}
