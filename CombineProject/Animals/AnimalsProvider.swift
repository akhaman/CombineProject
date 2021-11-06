//
//  AnimalsProvider.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import Foundation

protocol AnimalsProviderProtocol {
}

class AnimalsProvider {
    
    private let catFactsRepository: CatFactsRepositoryProtocol
    private let dogImageUrsRepository: DogImageUrlsRepositoryProtocol
    
    init(catFactsRepository: CatFactsRepositoryProtocol, dogImageUrsRepository: DogImageUrlsRepositoryProtocol) {
        self.catFactsRepository = catFactsRepository
        self.dogImageUrsRepository = dogImageUrsRepository
    }
}

// MARK: - AnimalsProviderProtocol

extension AnimalsProvider: AnimalsProviderProtocol {
}
