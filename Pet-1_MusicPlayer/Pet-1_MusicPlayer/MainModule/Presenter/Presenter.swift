//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

class Presenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var compactPlayerView: CompactPlayerViewProtocol?
    var networkservice: NetworkServiceProtocol?
    var player: AVPlayerProtocol?
    var userDefaults: UserDefaultsManagerProtocol!
    var searchResponce: SearchResponse?
    var favoriteTracks: [Track] = []
    var images: [UIImage?] = []
    var imagesSearch: [UIImage?] = []
    var isCompactPlayerShow: Bool? {
        get {
            return compactPlayerView?.isShow
        }
    }
    var currentIndex: Int!
    
    required init(view: MainViewProtocol, compactPlayer: CompactPlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, player: AVPlayerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.view = view
        self.networkservice = networkService
        self.router = router
        self.player = player
        self.player?.delegate = self
        self.compactPlayerView = compactPlayer
        self.userDefaults = userDefaultsManager
    }
    func mainViewLoaded() {
        userDefaults.loadData(forKey: "myTracks") { [weak self] tracks in
            self?.favoriteTracks = tracks
        }
        getImageResponce(responce: self.favoriteTracks)
    }
    func getSearchResponce(request: String) {
        networkservice?.searchTracksBy(request: request, complition: { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let responce):
                    self.searchResponce = responce
                    self.view?.sucsess()
                    self.getSearchImageResponce(responce: self.searchResponce?.results)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func getSearchImageResponce(responce: [Track]?) {
        guard let traks = responce else { return }
        self.imagesSearch.removeAll()
        DispatchQueue.global().sync {
            for track in traks {
                networkservice?.getImageBy(urlString: track.artworkUrl100, complition: { [weak self] (result) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.imagesSearch.append(image)
                            self.view?.sucsess()
                        case .failure(let error):
                            print("image error", error)
                        }
                    }
                })
            }
        }
    }
    func getImageResponce(responce: [Track]?) {
        guard let traks = responce else { return }
        self.images.removeAll()
        DispatchQueue.global().sync {
            for track in traks {
                networkservice?.getImageBy(urlString: track.artworkUrl100, complition: { [weak self] (result) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.images.append(image)
                            self.view?.sucsess()
                        case .failure(let error):
                            print("image error", error)
                        }
                    }
                })
            }
        }
    }
    
    func getTrackResponce(responce: Track) {
        DispatchQueue.global().sync {
                networkservice?.getTrackBy(urlString: responce.previewUrl, complition: {[weak self] (result) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self.player?.setup(data: data, currentItem: self.currentIndex)
                            self.compactPlayerView?.loadIndicator.stopAnimate()
                        case .failure(let error):
                            print("error load track \(error)")
                            
                        }
                    }
                })
        }
 
    }
    func dismissPlayer() {
        router?.dismissMusicPlayer()
    }
    
    func showCompactPlayer() {
        compactPlayerView?.showPlayerView()
    }
    
    func hideCompsctPlayer() {
        guard let compactPlayerView = compactPlayerView else {
            return
        }
        if compactPlayerView.isShow {
            compactPlayerView.hidePlayerView()
            self.player?.stop()
        }
    }
    func setupCompactPlayer(trackIndex: Int) {
        guard let player = player else { return }
        compactPlayerView?.setupValues(index: trackIndex)
        player.stop()
        compactPlayerView?.loadIndicator.startAnimate()
        self.getTrackResponce(responce: favoriteTracks[trackIndex])
    }
    
    func tapOnThePlayer() {
        let data = MusicData(tracks: favoriteTracks, images: images, correntItem: currentIndex, isPlaying: player?.isPlaying ?? false)
        router?.presentMusicPlauer(data: data)
    }
    
    func addTrackInFavorite(track: Track) {
        self.favoriteTracks.append(track)
        userDefaults.save(favoriteTracks, forKey: "myTracks")
        print(self.favoriteTracks.count)
    }
    func removeTrackInFavorite(index: Int) {
        self.favoriteTracks.remove(at: index)
        self.images.remove(at: index)
        
        
        if favoriteTracks.count == 0 {
            self.player?.stop()
            self.hideCompsctPlayer()
        } else if favoriteTracks.count > 0, currentIndex == index, currentIndex <= favoriteTracks.count - 1 {
            self.setupCompactPlayer(trackIndex: currentIndex)
        } else if currentIndex > favoriteTracks.count - 1 {
            currentIndex = favoriteTracks.count - 1
            player?.currentItem = currentIndex
            self.setupCompactPlayer(trackIndex: currentIndex)
        }
        userDefaults.save(self.favoriteTracks, forKey: "myTracks")
    }
    func changePlayerState(state: PlauerState) {
        switch state {
        case .play:
            player?.play()
        case .pause:
            player?.pause()
        case .stop:
            player?.stop()
        }
    }
    
}

extension Presenter: AVPlayerDelegate {
    func avPlayer(_ AVPlayer: AVPlayer, playerStateIs: PlauerState, currentItem: Int?) {
        compactPlayerView?.changeButtonState(state: playerStateIs)
        compactPlayerView?.setupValues(index: currentItem ?? 0)
        self.currentIndex = currentItem
    }

}
