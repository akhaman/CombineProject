//
//  AnimalsModels.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 07.11.2021.
//

import Foundation
import Combine
import UIKit

enum Animals {
    
    enum Segment: Int, CaseIterable {
        case cats
        case dogs
    }
    
    struct Input {
        let loadMore: AnyPublisher<Segment, Never>
        let segmentChanged: AnyPublisher<Segment, Never>
        let reset: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let score: String
        let content: ContentState
    }
    
    enum ContentState {
        case initial
        case loading
        case cats(fact: String)
        case dogs(image: UIImage)
    }
}

extension Animals.Segment {
    
    var name: String {
        switch self {
        case .cats:
            return "Cats"
        case .dogs:
            return "Dogs"
        }
    }
}
