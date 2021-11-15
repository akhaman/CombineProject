//
//  AnimalsAssembly.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 06.11.2021.
//

import UIKit

class AnimalsAssembly {
    
    class func assemble() -> UIViewController {
        let networker = Networker()
        
        let provider = AnimalsProvider(
            catFactsRepository: CatFactsRepository(networker: networker),
            dogImagesRepository: DogImagesRepository(networker: networker)
        )
        
        let viewController = AnimalsViewController(provider: provider)
        
        return viewController
    }
}
