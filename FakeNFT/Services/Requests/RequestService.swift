//
//  MakeRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

class RequestService {

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
}
