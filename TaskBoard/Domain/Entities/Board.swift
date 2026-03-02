// Created by Zhanibek Maratov

import Foundation

struct Board: Equatable {
    let id: UUID
    let name: String
    let createdAt: Date

    init(id: UUID = UUID(), name: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}
