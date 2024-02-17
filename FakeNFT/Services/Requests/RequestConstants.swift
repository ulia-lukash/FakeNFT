enum RequestConstants {
    static let baseURL = "https://64858e8ba795d24810b71189.mockapi.io"
    static let token = "58877909-79ca-45a2-afe0-c1f0bb21bde4"
    static let collectionsFetchEndpoint = "/api/v1/collections"
    static func fetchCollection(withId id: String) -> String {
        return "/api/v1/collections/\(id)"
    }
    static func fetchUser(withId id: String) -> String {
        return "/api/v1/users/\(id)"
    }
}
