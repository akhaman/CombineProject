//
//  DogsRepository.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import Foundation
import Combine

protocol DogImageUrlsRepositoryProtocol {
    func getImage() -> AnyPublisher<URL, Error>
}

class DogImageUrlsRepository {
    
    private let networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol) {
        self.networker = networker
    }
}

// MARK: - DogImageUrlsRepositoryProtocol

extension DogImageUrlsRepository: DogImageUrlsRepositoryProtocol {
    
    func getImage() -> AnyPublisher<URL, Error> {
        networker.request(Dog.self, url: URL(string: "https://dog.ceo/api/breeds/image/random")!)
            .map(\.url)
            .eraseToAnyPublisher()
    }
}

// MARK: - Response Model

extension DogImageUrlsRepository {
    private struct Dog: Decodable {
        let url: URL
        
        enum CodingKeys: String, CodingKey {
            case url = "message"
        }
    }
}
