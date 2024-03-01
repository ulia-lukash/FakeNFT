import Foundation

struct NFTData: Decodable {
    let id: String
    let images: [URL]
    let name: String
    let price: Float
    let rating: Int
}
