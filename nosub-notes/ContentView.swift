import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                    ForEach(notes) { note in
                        NavigationLink(destination: NoteView(note: note)) {
                            NoteCard(note: note)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                context.delete(note)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Notes")
            .toolbar {
                Button {
                    let newNote = Note(title: "New Note")
                    context.insert(newNote)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
