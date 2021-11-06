//
//  ViewController.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 05.11.2021.
//

import UIKit

class AnimalsViewController: UIViewController {

    private let provider: AnimalsProviderProtocol
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

