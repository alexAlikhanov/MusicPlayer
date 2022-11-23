//
//  Router.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import Foundation
import UIKit


protocol RouterMain{
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModuleBuilderProtocol?  { get set }
    
}

protocol RouterProtocol: RouterMain {
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol)
    func initialViewController()
    func presentMusicPlauer(data: MusicData?)
    func dismissMusicPlayer()
    func popToRoot()
}

class Router: RouterProtocol {

    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModuleBuilderProtocol?
    
    required init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func presentMusicPlauer(data: MusicData?) {
        if let navigationController = navigationController {
            guard let ViewController = assemblyBuilder?.createPlayerModule(router: self, data: data) else { return }
            
            ViewController.modalPresentationStyle = .currentContext
            navigationController.present(ViewController, animated: true)
        }
    }
    func dismissMusicPlayer() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    
}
