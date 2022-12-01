//
//  PlayerViewPresenterProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import Foundation

protocol PlayerViewPresenterProtocol: class{
    init (view: PlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, data: MusicData?, player: AVPlayerProtocol)
    var data: MusicData? { get set }
    var player: AVPlayerProtocol? { get set }
    var currentTrackTime: Float? { get set }
    func getTrackResponce(responce: Track)
    func setTrack()
    func back()
    func refrashData(currentTime: Float)
}
