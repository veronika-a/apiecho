//
//  NetworkService.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import Foundation

class NetworkService: NetworkDataProvider {
    private var accessToken: String = ""
    private let BASEURL = "https://apiecho.cf/doc/api"
    private var commonFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
        return dateFormatter
    }()

    func updateToken(accessToken: String) {
        self.accessToken = accessToken
    }

    func postSignup(parameters: [String: String], completion: @escaping (Result<Response<User>?, CallError>) -> Void) {
        var urlString = BASEURL + ""
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestPost(urlString: "https://apiecho.cf/api/signup/", parameters: parameters, completion: completion)
    }

    func postLogin(parameters: [String: String], completion: @escaping (Result<Response<User>?, CallError>) -> Void) {
        self.requestPost(urlString: "https://apiecho.cf/api/login/", parameters: parameters, completion: completion)
    }

    func getText(completion: @escaping (Result<Response<String>?, CallError>) -> Void) {
        self.requestGet(urlString: "https://apiecho.cf/api/get/text/", completion: completion)
    }

    private func requestGet<T: Decodable>(
        urlString: String,
        completion: @escaping (Result<T?, CallError>) -> Void) {
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            let requestHeaders: [String: String] = [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json; charset=utf-8" ]
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = requestHeaders
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        if let error = error as NSError?,
                           error.domain == NSURLErrorDomain &&
                            error.code == NSURLErrorNotConnectedToInternet {
                            completion(.failure(
                                .networkError("Please check your internet connection or try again later")))
                        } else {
                            completion(.failure(.unknownError(error)))
                        }
                    }
                    guard let data = data else {
                        completion(.failure(.unknownWithoutError))
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200..<300:
                            self?.decodeJson(type: T.self, from: data) { (result) in
                                switch result {
                                case .success(let decode):
                                    guard let decode = decode else {return}
                                    completion(.success(decode))
                                case .failure(let error):
                                    completion(.failure(error))
                                    print(error)
                                }
                            }
                        default:
                            break
                        }
                    }
                }
            }
            task.resume()
        }

    func requestPost<T: Decodable>(
        urlString: String,
        parameters: [String: String],
        completion: @escaping (Result<T?, CallError>) -> Void) {
        let requestHeaders: [String: String] = [
            "Content-Type": "application/json; charset=utf-8"]

        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = requestHeaders
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        print("parameters \(parameters)")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                guard let data = data else { return }
                if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    print("urlRequest: \(urlRequest) jsonDict: \(jsonDict)")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200..<300:
                        self.decodeJson(type: T.self, from: data) { (result) in
                            switch result {
                            case .success(let decode):
                                guard let decode = decode else {return}
                                completion(.success(decode))
                            case .failure(let error):
                                completion(.failure(error))
                                print(error)
                            }
                        }
                    default:
                        if let error = error {
                            completion(.failure(.unknownError(error)))
                            print("\(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        task.resume()
    }

    private func decodeJson<T: Decodable>(type: T.Type, from: Data?, completion: (Result<T?, CallError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let date = self.commonFormatter.date(from: dateStr) else { throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateStr)") }
            return date
        })
        guard let data = from else { return }
        do {
            let object = try decoder.decode(type.self, from: data)
            completion(.success(object))
        } catch let jsonError {
            completion(.failure(.jsonError(jsonError)))
        }
    }
}

// MARK: - NetworkDataProvider
protocol NetworkDataProvider {
}

enum CallError: Error {
    case networkError(String)
    case jsonError(Error)
    case unknownError(Error)
    case unknownWithoutError
}

struct Response<T:Decodable> : Decodable {
    var success: Bool
    var data: T?
    var errors: [ErrorObject]?
}

struct ErrorObject: Codable {
    var name: String?
    var message: String?
    var code: String?
    var status: Int?
}

struct User: Codable {
    var access_token: String
    var created_at: Int
    var email: String
    var name: String
    var role: Int
    var status: Int
    var uid: Int
    var updated_at: Int
}
