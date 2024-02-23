import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?
    
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
    
    @discardableResult
    func sendProfilePUT(request: NetworkRequest,
                        completionQueue: DispatchQueue,
                        onResponse: @escaping (Result<Void, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {
    
    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }
    
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private var profileTask: URLSessionTask?
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = createProfile(request: request) else { return nil }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let data = data {
                onResponse(.success(data))
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            } else {
                assertionFailure("Unexpected condition!")
                return
            }
        }
        
        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    @discardableResult
    func sendProfilePUT(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Void, Error>) -> Void
    ) -> NetworkTask? {
        guard profileTask == nil else { return nil }
        let onResponse: (Result<Void, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = createProfile(request: request) else { return nil }
        let task = session.dataTask(with: urlRequest) { _, response, error  in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            
            guard 200 == response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            onResponse(.success(()))
            profileTask?.cancel()
            
            if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            }
        }
        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func createProfile(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.setValue(ApiConstants.tockenValue,
                            forHTTPHeaderField: ApiConstants.tokenHeder)
        
        if let request = request as? ProfilePutRequest,
           let json = request.dto as? [String: String] {
            urlRequest.httpMethod = request.httpMethod.rawValue
            let jsonString = json.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
            guard let jsonString = jsonString.data(using: .utf8,
                                                   allowLossyConversion: false)
            else { return nil }
            urlRequest.setValue(ApiConstants.contentTypeValueGET,
                                forHTTPHeaderField: ApiConstants.acceptHeader)
            urlRequest.setValue(ApiConstants.contentTypeValuePUT ,
                                forHTTPHeaderField: ApiConstants.contenTypeHeader)
            urlRequest.httpBody = jsonString
        }
        return urlRequest
    }
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.setValue(ApiConstants.tockenValue,
                            forHTTPHeaderField: ApiConstants.tokenHeder)
        
        if let dto = request.dto as? String {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = Data(dto.utf8)
        }
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data, type _: T.Type,
                                     onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}
