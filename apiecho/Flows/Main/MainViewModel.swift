//
//  MainViewModel.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import Foundation

class MainViewModel {
    private let model: MainModel

    init(model: MainModel) {
        self.model = model
    }

    func singup(parameters: [String: String],
                completion: @escaping (Result<[String]?, CallError>) -> Void) {
        model.singup(parameters: parameters) { result in
            switch result {
            case .success(let success):
                guard let success = success else {return}
                let strings = self.frequencies(string: success.lowercased())
                completion(.success(strings))
            case .failure(let error):
                print(error)
            }
        }
    }

    func login(parameters: [String: String], completion: @escaping (Result<[String]?, CallError>) -> Void) {
        model.login(parameters: parameters) { result in
            switch result {
            case .success(let success):
                guard let success = success else {return}
                let strings = self.frequencies(string: success.lowercased())
                completion(.success(strings))
            case .failure(let error):
                print(error)
            }
        }
    }

    func frequencies(string: String) -> [String] {
        var frequencies = [Character: Int]()
        for character in string {
            if let counter = frequencies[character] {
                frequencies[character] = counter + 1
            } else {
                frequencies[character] = 1
            }
        }
        var freqStrings = [String]()
        for (key, value) in frequencies {
            freqStrings.append("\(key) - \(value)")
        }

        return freqStrings
    }
}
