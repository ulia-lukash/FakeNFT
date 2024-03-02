import Foundation

struct PutOrderRequest: NetworkRequest {
  // MARK: - Properties:
  var httpMethod: HttpMethod = .put
  var dto: Encodable?
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
  }
  // MARK: - Methods:
  init(nfts: [String]) {
    let queryString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
    self.dto = queryString
  }
}
