//
//  CompactPlayerViewProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import Foundation

protocol CompactPlayerViewProtocol: class {
    var isShow: Bool { get }
    var loadIndicator: LoadIndicator { get set }
    func showPlayerView()
    func hidePlayerView()
    func setupValues(index: Int)
    func changeButtonState(state: PlauerState )
}
