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
}

class AnimalsProvider {
    
    // MARK: - Dependencies
    
    private let catFactsRepository: CatFactsRepositoryProtocol
    private let dogImageUrsRepository: DogImageUrlsRepositoryProtocol
    
    // MARK: - State
    
    private var currentStateSubject = CurrentValueSubject<State, Never>(.initial)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(catFactsRepository: CatFactsRepositoryProtocol, dogImageUrsRepository: DogImageUrlsRepositoryProtocol) {
        self.catFactsRepository = catFactsRepository
        self.dogImageUrsRepository = dogImageUrsRepository
    }
    
    private func changeState(withSegment segment: AnimalsView.Segment) {
        
        switch segment {
        case .dogs:
            currentStateSubject.value.selectedSegment = .dogs
        case .cats:
            currentStateSubject.value.selectedSegment = .cats
        }
    }
    
    private func loadMore() {
    }
    
    private func resetState() {
        currentStateSubject.value = .initial
    }
    
    private func makeOutput(withState state: State) -> Animals.Output {
        let segmentState: Animals.Output.SegmentState
        
        switch state.selectedSegment {
        case .cats:
            segmentState = .cats(fact: state.catsContent.last)
        case .dogs:
            segmentState = .dogs(image: state.dogsContent.last)
        }
        
        return Animals.Output(
            segmentState: segmentState,
            scoreState: "Cats count: \(state.catsContent.count); dogs count: \(state.dogsContent.count)"
        )
    }
}

// MARK: - AnimalsProviderProtocol

extension AnimalsProvider: AnimalsProviderProtocol {
    
    var outputPublisher: AnyPublisher<Animals.Output, Never> {
        currentStateSubject
            .map(makeOutput(withState:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func bind(input: Animals.Input) {
        input.segmentChanged
            .sink { [unowned self] in changeState(withSegment: $0) }
            .store(in: &subscriptions)
        
        input.loadMore
            .sink { [unowned self] in loadMore() }
            .store(in: &subscriptions)
        
        input.reset
            .sink { [unowned self] in resetState() }
            .store(in: &subscriptions)
    }
}

// MARK: - AnimalsProvider State Model

extension AnimalsProvider {
    
    struct State {
        var dogsContent: [UIImage]
        var catsContent: [String]
        var selectedSegment: Segment
        
        static var initial: State {
            State(dogsContent: [], catsContent: [], selectedSegment: .cats)
        }
        
        enum Segment {
            case cats
            case dogs
        }
    }
}
