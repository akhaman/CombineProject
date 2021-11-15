//
//  UIControl+Combine.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit
import Combine

// MARK: - UIControl + CombineCompatible

extension UIControl: CombineCompatible {}

extension CombineCompatible where Self: UIControl {
    
    func publisher(for event: UIControl.Event) -> Publisher<Self> {
        Publisher(control: self, event: event)
    }
}

// MARK: - UIControl.Publisher

extension UIControl {
    
    struct Publisher<Control: UIControl>: Combine.Publisher {
        typealias Output = Control
        typealias Failure = Never
        
        let control: Control
        let event: Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
            let subscription = Subscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
}
// MARK: - UIControl.Subscription

extension UIControl {
    
    fileprivate final class Subscription<S: Subscriber, Control: UIControl>: Combine.Subscription where S.Input == Control {
        
        private var subscriber: S?
        private let control: Control
        private let event: Event
        private var currentDemand: Subscribers.Demand = .none
        
        init(subscriber: S, control: Control, event: Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            
            control.addTarget(self, action: #selector(handleEvent), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(handleEvent), for: event)
        }
        
        @objc private func handleEvent() {
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(control) ?? .none
                currentDemand -= 1
            }
        }
    }
}
