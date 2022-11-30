//
//  MainViewProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import Foundation

protocol MainViewProtocol: class {
    func sucsess()
    func failure(error: Error)
    func changeIndicator(index: Int, state: Bool )
    func setupPlayingTrackLineInTable(index: Int)
}
