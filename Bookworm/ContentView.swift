    //
    //  ContentView.swift
    //  Bookworm
    //
    //  Created by Hafizur Rahman on 26/12/25.
    //

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Book.title)]) var title: [Book]
    @Query(sort: [SortDescriptor(\Book.author)]) var author: [Book]
    
    @State private var filter = false
    @State private var showingAddScreen = false
    
    var books: [Book] { filter ? author : title }
    
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
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {
                        filter.toggle()
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
