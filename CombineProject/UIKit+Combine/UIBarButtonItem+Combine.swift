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
    var publisher: UIBarButtonItemPublisher {
        UIBarButtonItemPublisher(item: self)
    }
}

// MARK: - UIBarButton + init without target

extension UIBarButtonItem {
    convenience init(title: String, style: Style = .plain) {
        self.init(title: title, style: style, target: nil, action: nil)
    }
    
    convenience init(image: UIImage, style: Style = .plain) {
        self.init(image: image, style: style, target: nil, action: nil)
    }
}

// MARK: - UIBarButtonItemPublisher

extension UIBarButtonItem {
    struct UIBarButtonItemPublisher: Publisher {
        typealias Output = UIBarButtonItem
        typealias Failure = Never
        
        private let item: UIBarButtonItem
        
        init(item: UIBarButtonItem) {
            self.item = item
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIBarButtonItem == S.Input {
            let subscription = UIBarButtonItemSubscription(item: item, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - UIBarButtonItemSubscription

extension UIBarButtonItem {
    fileprivate class UIBarButtonItemSubscription<S: Subscriber>: Subscription where S.Input == UIBarButtonItem, S.Failure == Never {
        
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
