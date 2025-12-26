import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) var title: [Book]
    @Query(sort: [SortDescriptor(\Book.author, order: .reverse)]) var author: [Book]
    @Query(sort: [SortDescriptor(\Book.date, order: .reverse)]) var date: [Book]
    
    @State private var showingAddScreen = false
    @State private var filter: Filter = .title
    
    enum Filter: String, CaseIterable, Identifiable {
        case title, author, date
        var id: String { rawValue }
        var title: String { rawValue.capitalized }
        
        var icon: String {
            switch self {
                case .title:  return "textformat"
                case .author: return "person"
                case .date:   return "calendar"
            }
        }
    }

    
    var books: [Book] {
        switch filter {
            case .title: return title
            case .author: return author
            case .date: return date
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating < 2 ? .red : .primary)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Bookwarm")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $filter.animation()) {
                            ForEach(Filter.allCases) { option in
                                Label(option.title, systemImage: option.icon)
                                    .tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func delete(for offSet: IndexSet) {
        for index in offSet {
            let book = books[index]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self)
}
