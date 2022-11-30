//
//  RouterProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

protocol RouterMain{
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModuleBuilderProtocol?  { get set }
}

protocol RouterProtocol: RouterMain {
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol, networkService: NetworkServiceProtocol, player: AVPlayerProtocol)
    func initialViewController()
    func presentMusicPlauer(data: MusicData?)
    func dismissMusicPlayer()
    func popToRoot()
}
