import Foundation

struct Nft: Codable, Equatable {
    let name: String
    let images: [String]
    let rating: Double
    let description: String
    let price: Double
    let author: String
    let id: String
}
