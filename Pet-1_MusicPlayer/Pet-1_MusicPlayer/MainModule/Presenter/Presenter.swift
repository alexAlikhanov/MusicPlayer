//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

enum MusicArray {
    case favorite
    case search
}
class Presenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var compactPlayerView: CompactPlayerViewProtocol?
    var networkservice: NetworkServiceProtocol?
    var player: AVPlayerProtocol?
    var userDefaults: UserDefaultsManagerProtocol!
    var searchResponce: SearchResponse?
    var favoriteTracks: [Track] = []
    var currentTracks: [Track] = []
    var images: [UIImage?] = []
    var imagesSearch: [UIImage?] = []
    var currentImages: [UIImage?] = []
    var isCompactPlayerShow: Bool? {
        get {
            return compactPlayerView?.isShow
        }
    }
    var currentIndex: Int!
    var selectedArray: MusicArray
    
    required init(view: MainViewProtocol, compactPlayer: CompactPlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, player: AVPlayerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.view = view
        self.networkservice = networkService
        self.router = router
        self.player = player
        self.compactPlayerView = compactPlayer
        self.userDefaults = userDefaultsManager
        self.currentIndex = 0
        self.selectedArray = .favorite
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerTick(_:)), name: Notification.Name ("AVPlayerTick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerState(_:)), name: Notification.Name( "AVPlayerState"), object: nil)
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
            self.player?.pause()
        }
    }
    func setupCompactPlayer(forArray: MusicArray, trackIndex: Int) {
        switch forArray {
        case .favorite:
            self.currentTracks = favoriteTracks
            self.currentImages = images
        case .search:
            self.currentTracks = self.searchResponce?.results ?? []
            self.currentImages = imagesSearch
        }
        compactPlayerView?.setupValues(forArray: forArray, index: trackIndex, id: currentTracks[trackIndex].trackId!)
        compactPlayerView?.loadIndicator.startAnimate()
        self.getTrackResponce(responce: currentTracks[trackIndex])
    }
    
    func tapOnThePlayer(forArray: MusicArray) {
        switch forArray {
        case .favorite:
            let data = MusicData(tracks: currentTracks, images: currentImages, correntItem: currentIndex, isPlaying: player?.isPlaying ?? false, currentAlbom: "Моя музыка")
            router?.presentMusicPlauer(data: data)
        case .search:
            let data = MusicData(tracks: currentTracks, images: currentImages, correntItem: currentIndex, isPlaying: player?.isPlaying ?? false, currentAlbom: "по результатам поиска")
            router?.presentMusicPlauer(data: data)
        }
       
    }
    
    func addTrackInFavorite(track: Track) {
        self.favoriteTracks.append(track)
        userDefaults.save(favoriteTracks, forKey: "myTracks")
        getImageResponce(responce: self.favoriteTracks)
        view?.update()
    }
    func removeTrackInFavorite(index: Int?, id: Int?) {
        var ind = Int()
        if id != nil {
            ind = favoriteTracks.firstIndex(where: {$0.trackId == id}) ?? 0
            self.favoriteTracks.remove(at: ind)
            view?.update()
        } else if index != nil {
            ind = index!
            self.favoriteTracks.remove(at: ind)
            self.images.remove(at: ind)
        } else { return }

        userDefaults.save(self.favoriteTracks, forKey: "myTracks")
        
    }
    func changePlayerState(state: PlayerState) {
        switch state {
        case .play:
            player?.play()
        case .pause:
            player?.pause()
        case .stop:
            player?.stop()
        }
    }

    @objc func avPlayerState(_ notification: Notification) {
        let data = notification.object as! (playerStateIs: PlayerState, currentItem: Int?)
        print(data.playerStateIs)
        compactPlayerView?.changeButtonState(state: data.playerStateIs)
       
            if data.playerStateIs == .stop {
                if currentIndex < currentTracks.count - 1 {
                    currentIndex = currentIndex + 1
                    setupCompactPlayer(forArray: .favorite, trackIndex: currentIndex)
                    view?.setupPlayingTrackLineInTable(index: currentIndex)
                }
                if currentIndex == currentTracks.count - 1 {
                    player?.pause()
                }
            }
            if data.playerStateIs == .play {
                compactPlayerView?.setupValues(forArray: .favorite, index: data.currentItem ?? 0, id: currentTracks[data.currentItem!].trackId!)
                currentIndex = data.currentItem
                view?.setupPlayingTrackLineInTable(index: currentIndex)
                compactPlayerView?.loadIndicator.stopAnimate()
            }      
    }
    
    @objc func avPlayerTick(_ notification: Notification) {
        
    }
        
}
    
