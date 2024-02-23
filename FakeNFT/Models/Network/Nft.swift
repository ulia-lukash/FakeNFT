import Foundation

struct Nft: Decodable, Equatable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
    let id: String
}
