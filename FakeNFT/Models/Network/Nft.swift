import Foundation

struct Nft: Codable {
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: URL
    let id: UUID
}
