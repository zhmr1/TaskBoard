// Created by Zhanibek Maratov

import Foundation

protocol BoardRepositoryProtocol {
    func fetchAll() -> [Board]
    func create(name: String) -> Board
    func delete(id: UUID)
}
