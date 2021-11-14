//
//  CatsRepository.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import Foundation
import Combine

protocol CatFactsRepositoryProtocol {
    func getCatFact() -> AnyPublisher<String, Error>
}

class CatFactsRepository {
        
    private let networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol) {
        self.networker = networker
    }
}

// MARK: - CatFactsRepositoryProtocol

extension CatFactsRepository: CatFactsRepositoryProtocol {
    
    func getCatFact() -> AnyPublisher<String, Error> {
        networker.request(Cat.self, url: URL(string: "https://catfact.ninja/fact")!)
            .map(\.fact)
            .eraseToAnyPublisher()
    }
}

// MARK: - Cat Response

extension CatFactsRepository {
    private struct Cat: Decodable {
        let fact: String
    }
}
