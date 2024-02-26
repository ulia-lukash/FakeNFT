import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    static let token = "58877909-79ca-45a2-afe0-c1f0bb21bde4"
    static let collectionsFetchEndpoint = "/api/v1/collections"
    static let nftsFetchEndpoint = "/api/v1/nft"
    static let profileFetchEndpoint = "/api/v1/profile/1"
    static let orderFetchEndpoint = "/api/v1/orders/1"

    static let currenciesFetchEndpoint = "/api/v1/currencies"
    static func fetchCollection(withId id: String) -> String {
        return "/api/v1/collections/\(id)"
    }
    static func fetchUser(withId id: String) -> String {
        return "/api/v1/users/\(id)"
    }
    static func fetchNft(withId id: String) -> String {
        return "/api/v1/nft/\(id)"
    }
    
    static func fetchNfts(forPage page: Int) -> String {
        return "/api/v1/nft?page=\(page)&size=10"
    }
}
