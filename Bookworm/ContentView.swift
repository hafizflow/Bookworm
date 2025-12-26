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
    @Query var students: [Student]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(students) { student in
                    Text(student.name)
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Students")
            .toolbar {
                Button("Add Student") {
                    let firstName = ["Hafiz", "Nishat", "Anjum"]
                    let lastName = ["5678", "5586", "5801"]
                    
                    let name = "\(firstName.randomElement()!) \(lastName.randomElement()!)"
                    let student = Student(id: UUID(), name: name)
                    
                    modelContext.insert(student)
                }
            }
        }
    }
    
    func delete(for offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(students[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Student.self)
}
