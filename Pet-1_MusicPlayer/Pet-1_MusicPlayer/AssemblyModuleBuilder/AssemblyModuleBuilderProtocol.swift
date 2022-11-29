//
//  AssemblyModuleBuilderProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//
import UIKit

protocol AssemblyModuleBuilderProtocol{
    func createMainModule(router: RouterProtocol, player: AVPlayerProtocol) -> UIViewController
    func createPlayerModule(router: RouterProtocol, data: MusicData?, player: AVPlayerProtocol) -> UIViewController
}
