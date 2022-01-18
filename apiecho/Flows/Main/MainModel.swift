//
//  MainModel.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import Foundation

class MainModel {
    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func singup(parameters: [String: String], completion: @escaping (Result<String?, CallError>) -> Void) {
        service.postSignup(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self, let response = response, let user = response.data else {return}
                self.service.updateToken(accessToken: user.access_token)
                print(response)
                self.getText(completion: completion)
            case .failure(let error):
                print(error)
            }
        }
    }

    func login(parameters: [String: String], completion: @escaping (Result<String?, CallError>) -> Void) {
        service.postLogin(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self, let response = response, let user = response.data else {return}
                self.service.updateToken(accessToken: user.access_token)
                self.getText(completion: completion)
            case .failure(let error):
                print(error)
            }
        }
    }

    func getText(completion: @escaping (Result<String?, CallError>) -> Void) {
        service.getText { result in
            switch result {
            case .success(let response):
                guard let response = response, let text = response.data  else {return}
                print(response)
                completion(.success(text))
            case .failure(let error):
                print(error)
            }
        }
    }
}
