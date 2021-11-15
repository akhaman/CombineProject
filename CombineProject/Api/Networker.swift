//
//  NetworkRepository.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import Foundation
import Combine

protocol NetworkerProtocol {
    func request<T: Decodable>(_ responseType: T.Type, url: URL) -> AnyPublisher<T, Error>
    func request(dataWith url: URL) -> AnyPublisher<Data, Error>
}

class Networker: NetworkerProtocol {
    
    private let session: URLSession = .shared
    private let decoder = JSONDecoder()
    
    func request<T: Decodable>(_ responseType: T.Type, url: URL) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: responseType.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func request(dataWith url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
