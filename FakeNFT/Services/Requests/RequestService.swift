//
//  MakeRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

class RequestService {

    let urlSession = URLSession.shared
    func makeGetRequest(path: String) -> URLRequest? {

        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            assertionFailure("Couldn't resolve BASE URL")
            return nil
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to assemble REQUEST URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }

    func makePutRequest(path: String, data: Data) -> URLRequest? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            assertionFailure("Couldn't resolve BASE URL")
            return nil
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to assemble REQUEST URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpBody = data
        return request
    }
    
    func putData(_ data: [UUID], url: String, isLikes: Bool) {
        let data = data.map {$0.uuidString.lowercased()}
        
        let dataString = data.map { isLikes ? "likes=\($0)" : "nfts=\($0)"}.joined(separator: "&")
        let reqData = Data(dataString.utf8)

        guard let request = makePutRequest(
            path: url,
            data: reqData) else { assertionFailure("Failed to make likes put request")
            return
        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let _ = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                } else {
                    print(NetworkError.httpStatusCode(statusCode))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
            } else {
                print(NetworkError.urlSessionError)
            }
        }
        task.resume()
    }
}
