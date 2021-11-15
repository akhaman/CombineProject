//
//  AnimalsView.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit
import SnapKit
import Combine

class AnimalsView: UIView {
    
    // MARK: - Subviews
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = Animals.Segment.allCases.map(\.name)
        let control = UISegmentedControl(items: items)
        return control
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = .init(red: 255/255, green: 155/255, blue: 138/255, alpha: 1)
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var contentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moreButton.layer.cornerRadius = moreButton.frame.height / 2
    }
    
    // MARK: - Initial Configuration
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(27)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 196, height: 32))
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(41)
            $0.leading.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(204)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 144, height: 40))
        }
        
        addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.greaterThanOrEqualToSuperview().inset(19)
        }
        
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(loader)
        loader.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - AnimalsView Publishers

extension AnimalsView {
    
    var segmentPublisher: AnyPublisher<Animals.Segment, Never> {
        segmentedControl
            .publisher(for: .valueChanged)
            .compactMap { Animals.Segment(rawValue: $0.selectedSegmentIndex) }
            .eraseToAnyPublisher()
    }
    
    var loadMorePublisher: AnyPublisher<Animals.Segment, Never> {
        moreButton
            .publisher(for: .touchUpInside)
            .compactMap { [unowned self] _ in Animals.Segment(rawValue: segmentedControl.selectedSegmentIndex) }
            .eraseToAnyPublisher()
    }
}

// MARK: - AnimalsView Updating

extension AnimalsView {
    
    func update(score: String) {
        scoreLabel.text = score
    }
    
    func update(contentState: Animals.ContentState) {
        
        switch contentState {
        case .loading:
            contentLabel.hide()
            contentImageView.hide()
            loader.startAnimating()
        case .cats(let fact):
            contentLabel.text = fact
            contentLabel.show()
            contentImageView.hide()
            loader.stopAnimating()
        case .dogs(let image):
            contentImageView.image = image
            contentImageView.show()
            contentLabel.hide()
            loader.stopAnimating()
        }
    }
    
    func update(selectedSegment: Animals.Segment) {
        segmentedControl.selectedSegmentIndex = selectedSegment.rawValue
    }
}
