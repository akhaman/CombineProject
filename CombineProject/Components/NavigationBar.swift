//
//  NavigationBar.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit

class NavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Initial Configuration
    
    private func setup() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        
        compactAppearance = appearance
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        
        prefersLargeTitles = true
        isTranslucent = false
    }
}
