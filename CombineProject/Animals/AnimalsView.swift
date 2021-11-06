//
//  AnimalsView.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit
import SnapKit

class AnimalsView: UIView {
    
    enum Segment: Int, CaseIterable {
        case cats
        case dogs
        
        var name: String {
            switch self {
            case .cats:
                return "Cats"
            case .dogs:
                return "Dogs"
            }
        }
    }

    // MARK: - Subviews
    
    private(set) lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: Segment.allCases.map(\.name))
        control.selectedSegmentIndex = 0
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
    
    private(set) lazy var contentImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = .init(red: 255/255, green: 155/255, blue: 138/255, alpha: 1)
        button.layer.masksToBounds = true
        return button
    }()
    
    private(set) lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Score: 5 cats and 11 dogs"
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
            $0.center.edges.equalToSuperview()
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.edges.equalToSuperview().inset(16)
        }
    }
}
