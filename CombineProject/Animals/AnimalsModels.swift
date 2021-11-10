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
    
    struct Input {
        let loadMore: AnyPublisher<Void, Never>
        let segmentChanged: AnyPublisher<AnimalsView.Segment, Never>
        let reset: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let segmentState: SegmentState
        let scoreState: String
    }
}

extension Animals.Output {
    
    enum SegmentState {
        case cats(fact: String?)
        case dogs(image: UIImage?)
    }
}
