//
//  ViewController.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 05.11.2021.
//

import UIKit
import Combine

class AnimalsViewController: UIViewController {
    
    private let provider: AnimalsProviderProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Subviews
    
    private lazy var animalsView = AnimalsView()
    private lazy var resetButton = UIBarButtonItem(title: "Reset")
    
    // MARK: - Initialization
    
    init(provider: AnimalsProviderProtocol) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = animalsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewsInput()
        bindProvidersOutput()
        animalsView.update(selectedSegment: .cats)
        provider.load(initialSegment: .cats)
    }
    
    private func setup() {
        title = "Cats and dogs"
        navigationItem.rightBarButtonItem = resetButton
    }
    
    // MARK: - Bindings
    
    private func bindViewsInput() {
        let resetPublisher = resetButton
            .publisher
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let input = Animals.Input(
            loadMore: animalsView.loadMorePublisher,
            segmentChanged: animalsView.segmentPublisher,
            reset: resetPublisher
        )
        
        provider.bind(input: input)
    }
    
    private func bindProvidersOutput() {
        provider.outputPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] output in
                self?.animalsView.update(score: output.score)
                self?.animalsView.update(contentState: output.content)
            }
            .store(in: &subscriptions)
    }
}
