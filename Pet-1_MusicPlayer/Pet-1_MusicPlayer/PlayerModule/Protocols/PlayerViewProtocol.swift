//
//  PlayerViewProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import Foundation

protocol PlayerViewProtocol: class{
    func setTrack(data: MusicData?)
    func action(flag: Bool)
}
