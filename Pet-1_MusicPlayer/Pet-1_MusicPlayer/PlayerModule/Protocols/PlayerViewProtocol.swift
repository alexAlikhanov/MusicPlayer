//
//  PlayerViewProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import Foundation

protocol PlayerViewProtocol: AnyObject{
    func setTrack(data: MusicData?)
    func action(flag: Bool)
    func setupPlayingTrackLineInCollecrion(index: Int)
    func refrashSlider(currentTime: TimeInterval, duration: TimeInterval)
}
