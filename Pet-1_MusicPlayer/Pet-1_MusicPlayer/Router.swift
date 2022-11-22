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
    func presentMusicPlauer()
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
    
    func presentMusicPlauer() {
        if let navigationController = navigationController {
            guard let ViewController = assemblyBuilder?.createPlayerModule(router: self) else { return }
            
            ViewController.modalPresentationStyle = .overCurrentContext
            navigationController.present(ViewController, animated: false)
        }
    }
    func dismissMusicPlayer() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: false, completion: nil)
        }
    }
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

    
}
