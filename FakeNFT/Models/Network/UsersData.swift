import Foundation

struct UserData: Decodable {
    let name: String
    let avatar: URL
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
