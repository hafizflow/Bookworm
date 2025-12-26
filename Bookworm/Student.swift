//
//  Student.swift
//  Bookworm
//
//  Created by Hafizur Rahman on 26/12/25.
//

import SwiftData
import SwiftUI

@Model
class Student {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
