import SwiftUI
import SwiftData

struct NoteView: View {
    @Bindable var note: Note
    @Environment(\.dismiss) private var dismiss
    @State private var currentPageIndex = 0

    var currentPage: NotePage {
        // Handle legacy notes with drawingData but no pages
        if note.pages.isEmpty {
            let firstPage = NotePage(pageNumber: 0)
            firstPage.drawingData = note.drawingData
            note.pages.append(firstPage)
        }
        return note.pages[currentPageIndex]
    }

    var body: some View {
        ZStack {
            CanvasView(drawingData: Binding(
                get: { currentPage.drawingData },
                set: { currentPage.drawingData = $0 }
            ))
            .ignoresSafeArea(.all)
            .id(currentPageIndex) // Force refresh when page changes

            // Floating back button (top left)
            VStack {
                HStack {
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

                    Spacer()
                }
                Spacer()
            }

            // Page navigation (top right)
            VStack {
                HStack {
                    Spacer()

                    HStack(spacing: 12) {
                        // Previous page button
                        Button {
                            if currentPageIndex > 0 {
                                currentPageIndex -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(currentPageIndex > 0 ? .primary : .gray)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .disabled(currentPageIndex == 0)

                        // Page indicator
                        Text("\(currentPageIndex + 1) / \(note.pages.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                        // Next/Add page button
                        Button {
                            if currentPageIndex < note.pages.count - 1 {
                                currentPageIndex += 1
                            } else {
                                // Add new page
                                let newPage = NotePage(pageNumber: note.pages.count)
                                note.pages.append(newPage)
                                currentPageIndex = note.pages.count - 1
                            }
                        } label: {
                            Image(systemName: currentPageIndex < note.pages.count - 1 ? "chevron.right" : "plus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
