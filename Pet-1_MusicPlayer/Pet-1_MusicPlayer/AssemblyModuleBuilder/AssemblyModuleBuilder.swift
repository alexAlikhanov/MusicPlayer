//
//  AssemblyModuleBuilder.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

protocol AssemblyModuleBuilderProtocol{
    func createMainModule(router: RouterProtocol, player: AVPlayerProtocol) -> UIViewController
    func createPlayerModule(router: RouterProtocol, data: MusicData?, player: AVPlayerProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createMainModule(router: RouterProtocol, player: AVPlayerProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let compactPlayerView = CompactPlayerView.shared
        let userDefaultsManager = UserDefaultsManager.shared
        let presenter = Presenter(view: view, compactPlayer: compactPlayerView, router: router, networkService: networkService, player: player, userDefaultsManager: userDefaultsManager)
        view.presenter = presenter
        compactPlayerView.presenter = presenter
        return view
    }
    
    func createPlayerModule(router: RouterProtocol, data: MusicData?, player: AVPlayerProtocol) -> UIViewController {
        let view = PlayerViewController()
        let networkService = NetworkService()
        let presenter = PlayerPresenter(view: view, router: router, networkService: networkService, data: data, player: player)
        view.presenter = presenter
        return view
    }
    
}
