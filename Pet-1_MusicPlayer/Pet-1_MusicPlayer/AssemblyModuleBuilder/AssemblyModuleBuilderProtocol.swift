//
//  AssemblyModuleBuilderProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//
import UIKit

protocol AssemblyModuleBuilderProtocol{
    func createMainModule(router: RouterProtocol, networkService: NetworkServiceProtocol, player: AVPlayerProtocol) -> UIViewController
    func createPlayerModule(router: RouterProtocol, data: MusicData?, networkService: NetworkServiceProtocol, player: AVPlayerProtocol) -> UIViewController
}
