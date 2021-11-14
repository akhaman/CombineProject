//
//  AnimalsProvider.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import Foundation
import UIKit
import Combine

protocol AnimalsProviderProtocol {
    var outputPublisher: AnyPublisher<Animals.Output, Never> { get }
    func bind(input: Animals.Input)
    func load(initialSegment: Animals.Segment)
}

class AnimalsProvider {
    
    // MARK: - Dependencies
    
    private let catFactsRepository: CatFactsRepositoryProtocol
    private let dogImageUrsRepository: DogImageUrlsRepositoryProtocol
    
    // MARK: - Internal State
    
    private var dogs: [UIImage] = []
    private var cats: [String] = []
    private var selectedSegment: Animals.Segment?
    
    private lazy var outputSubject = CurrentValueSubject<Animals.Output, Never>(output(withState: .initial))
    
    private var viewsSubscriptions = Set<AnyCancellable>()
    private var loadingSubscription: AnyCancellable?
    
    // MARK: - Initialization
    
    init(catFactsRepository: CatFactsRepositoryProtocol, dogImageUrsRepository: DogImageUrlsRepositoryProtocol) {
        self.catFactsRepository = catFactsRepository
        self.dogImageUrsRepository = dogImageUrsRepository
    }
    
    private func loadDogs() {
        loadingSubscription?.cancel()
        
        outputSubject.value = output(withState: .loading)
        
        loadingSubscription = dogImageUrsRepository.getDogImage()
            .sink { _ in
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.dogs.append(image)
                self.outputSubject.value = self.output(withState: .dogs(image: image))
            }
    }
    
    private func loadCats() {
        loadingSubscription?.cancel()
        
        outputSubject.value = output(withState: .loading)
        
        loadingSubscription = catFactsRepository.getCatFact()
            .sink { _ in
            } receiveValue: { [weak self] fact in
                guard let self = self else { return }
                self.cats.append(fact)
                self.outputSubject.value = self.output(withState: .cats(fact: fact))
            }
    }

    private func resetData() {
        cats.removeAll()
        dogs.removeAll()
        
        switch selectedSegment {
        case .cats:
            loadCats()
        case .dogs:
            loadDogs()
        case .none:
            break
        }
    }
    
    private func output(withState state: Animals.ContentState) -> Animals.Output {
        Animals.Output(score: "Score: \(cats.count) cats \(dogs.count) dogs", content: state)
    }
}

// MARK: - AnimalsProviderProtocol

extension AnimalsProvider: AnimalsProviderProtocol {
    
    var outputPublisher: AnyPublisher<Animals.Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    func bind(input: Animals.Input) {
        input.segmentChanged
            .sink { [unowned self] segment in
                selectedSegment = segment
                switch segment {
                case .dogs:
                    guard let dog = dogs.last else { return loadDogs() }
                    outputSubject.value = output(withState: .dogs(image: dog))
                case .cats:
                    guard let fact = cats.last else { return loadCats() }
                    outputSubject.value = output(withState: .cats(fact: fact))
                }
            }
            .store(in: &viewsSubscriptions)
        
        input.loadMore
            .sink { [unowned self] segment in
                switch segment {
                case .dogs:
                    loadDogs()
                case .cats:
                    loadCats()
                }
            }
            .store(in: &viewsSubscriptions)
        
        input.reset
            .sink { [unowned self] in resetData() }
            .store(in: &viewsSubscriptions)
    }
    
    func load(initialSegment: Animals.Segment) {
        selectedSegment = initialSegment
        
        switch initialSegment {
        case .dogs:
            loadDogs()
        case .cats:
            loadCats()
        }
    }
}
