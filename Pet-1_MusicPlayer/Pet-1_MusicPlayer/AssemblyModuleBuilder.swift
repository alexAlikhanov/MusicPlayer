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
    func createPlayerModule(router: RouterProtocol, data: MusicData?) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let compactPlayerView = CompactPlayerView.shared
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = Presenter(view: view, compactPlayer: compactPlayerView, router: router, networkService: networkService, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        compactPlayerView.presenter = presenter
        return view
    }
    
    func createPlayerModule(router: RouterProtocol, data: MusicData?) -> UIViewController {
        let view = PlayerViewController()
        let presenter = PlayerPresenter(view: view, router: router, data: data)
        view.presenter = presenter
        return view
    }
    
}
