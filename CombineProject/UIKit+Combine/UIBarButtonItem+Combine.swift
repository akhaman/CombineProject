//
//  UIBarButtonItem+Combine.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit
import Combine

// MARK: - UIBarButtonItem + Publisher

extension UIBarButtonItem {
    var publisher: Publisher {
        Publisher(item: self)
    }
}

// MARK: - UIBarButton + Convience Initialization

extension UIBarButtonItem {
    
    convenience init(
        title: String,
        style: Style = .plain,
        storeIn cancellables: inout Set<AnyCancellable>,
        action: @escaping () -> Void
    ) {
        self.init(title: title, style: style, target: nil, action: nil)
        publisher.sink { _ in action() }.store(in: &cancellables)
    }
    
    convenience init(
        image: UIImage,
        style: Style = .plain,
        storeIn cancellables: inout Set<AnyCancellable>,
        action: @escaping () -> Void
    ) {
        self.init(image: image, style: style, target: nil, action: nil)
        publisher.sink { _ in action() }.store(in: &cancellables)
    }
}

// MARK: - UIBarButtonItem.Publisher

extension UIBarButtonItem {
    
    struct Publisher: Combine.Publisher {
        typealias Output = UIBarButtonItem
        typealias Failure = Never
        
        private let item: UIBarButtonItem
        
        init(item: UIBarButtonItem) {
            self.item = item
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIBarButtonItem == S.Input {
            let subscription = Subscription(item: item, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - UIBarButtonItem.Subscription

extension UIBarButtonItem {
    
    fileprivate final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == UIBarButtonItem, S.Failure == Never {
        
        private let item: UIBarButtonItem
        private var subscriber: S?
        private var currentDemand: Subscribers.Demand = .none
        
        init(item: UIBarButtonItem, subscriber: S) {
            self.item = item
            self.subscriber = subscriber
            
            item.target = self
            item.action = #selector(itemDidTap)
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
           subscriber = nil
            item.target = nil
            item.action = nil
        }
        
        @objc private func itemDidTap() {
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(item) ?? .none
                currentDemand -= 1
            }
        }
    }
}
