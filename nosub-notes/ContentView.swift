import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
    @State private var showingAddNote = false
    @State private var newNoteName = ""

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
                    newNoteName = ""
                    showingAddNote = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .alert("New Note", isPresented: $showingAddNote) {
                TextField("Note name", text: $newNoteName)
                Button("Cancel", role: .cancel) { }
                Button("Create") {
                    let noteName = newNoteName.isEmpty ? "Untitled" : newNoteName
                    let newNote = Note(title: noteName)
                    context.insert(newNote)
                }
            } message: {
                Text("Enter a name for your note")
            }
        }
    }
}
