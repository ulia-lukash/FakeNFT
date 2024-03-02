import Foundation

struct LikesRequest: NetworkRequest {
  // MARK: - Properties:
  var httpMethod: HttpMethod = .put
  var dto: Encodable?
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
  }
  // MARK: - Methods:
  init(nfts: [String]) {
    let queryString = nfts.map { "likes=\($0)" }.joined(separator: "&")
    self.dto = queryString
  }
}
