//
//  AssemblyModuleBuilder.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

protocol AssemblyModuleBuilderProtocol{
    func createMainModule() -> UIViewController
}

class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = Presenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }

}
