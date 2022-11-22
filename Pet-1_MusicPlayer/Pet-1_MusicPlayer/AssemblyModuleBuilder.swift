//
//  AssemblyModuleBuilder.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

protocol AssemblyModuleBuilderProtocol{
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createPlayerModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = Presenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createPlayerModule(router: RouterProtocol) -> UIViewController {
        let view = PlayerViewController()
        let presenter = PlayerPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
}
