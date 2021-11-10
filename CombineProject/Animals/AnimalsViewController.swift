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
        setupView()
        bindViews()
        bindData()
    }
    
    private func setupView() {
        title = "Cats and dogs"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = resetButton
    }
    
    // MARK: - Bindings
    
    private func bindViews() {
        let loadMorePublisher = animalsView.moreButton
            .publisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let segmentPublisher = animalsView.segmentedControl
            .publisher(for: .valueChanged)
            .compactMap { AnimalsView.Segment(rawValue: $0.selectedSegmentIndex) }
            .eraseToAnyPublisher()
        
        let resetPublisher = resetButton
            .publisher
            .map { _ in () }
            .eraseToAnyPublisher()
        
        let input = Animals.Input(loadMore: loadMorePublisher, segmentChanged: segmentPublisher, reset: resetPublisher)
        
        provider.bind(input: input)
    }
    
    private func bindData() {
        provider.outputPublisher
            .sink { [weak self] in self?.update(withState: $0) }
            .store(in: &subscriptions)
    }
    
    // MARK: - State updating
    
    private func update(withState state: Animals.Output) {
        self.animalsView.scoreLabel.text = state.scoreState
        
        switch state.segmentState {
        case .dogs(let image):
            self.animalsView.contentImageView.image = image
            self.animalsView.contentImageView.isHidden = false
            self.animalsView.contentLabel.isHidden = true
        case .cats(let fact):
            self.animalsView.contentLabel.text = fact
            self.animalsView.contentLabel.isHidden = false
            self.animalsView.contentImageView.isHidden = true
        }
    }
}
