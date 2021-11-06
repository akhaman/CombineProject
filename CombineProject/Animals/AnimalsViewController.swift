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
    }
    
    private func setupView() {
        title = "Cats and dogs"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", storeIn: &subscriptions) { print("didTap") }
    }
    
    private func bindViews() {
    }
}
