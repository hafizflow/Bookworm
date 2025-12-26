import SwiftData
import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var genre: String = "Fantasy"
    @State private var review: String = ""
    @State private var rating: Int = 3
    @State private var date: Date = .now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var isNonValid: Bool {
        if title.isEmpty || author.isEmpty || review.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Review & Rating") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        let book = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: date)
                        modelContext.insert(book)
                        dismiss()
                    }
                }
                .disabled(isNonValid)
            }
            .navigationTitle("Add Book")
            .toolbar {
                Button("Cancel", systemImage: "multiply", action: { dismiss() })
            }
        }
    }
}

#Preview {
    AddBookView()
}
