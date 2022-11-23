//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

protocol MainViewProtocol: class {
    func sucsess()
    func failure(error: Error)
}

protocol CompactPlayerViewProtocol: class {
    var isShow: Bool { get }
    func showPlayerView()
    func hidePlayerView()
    func setupValues(index: Int)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, compactPlayer: CompactPlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, userDefaultsManager: UserDefaultsManagerProtocol)
    var searchResponce: SearchResponse? { get set }
    var favoriteTracks: [Track] { get set }
    var images: [UIImage?] { get set }
    var isCompactPlayerShow: Bool? { get }
    var currentIndex: Int! { get set }
    func mainViewLoaded()
    func getSearchResponce(request: String)
    func getImageResponce(responce: [Track]?)
    func addTrackInFavorite(track: Track)
    func removeTrackInFavorite(index: Int)
    func showCompactPlayer()
    func hideCompsctPlayer()
    func setupCompactPlayer(trackIndex: Int)
    func tapOnThePlayer()
    func dismissPlayer()
}

class Presenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var compactPlayerView: CompactPlayerViewProtocol?
    var networkservice: NetworkServiceProtocol?
    var userDefaults: UserDefaultsManagerProtocol!
    var searchResponce: SearchResponse?
    var favoriteTracks: [Track] = []
    var images: [UIImage?] = []
    var isCompactPlayerShow: Bool? {
        get {
            return compactPlayerView?.isShow
        }
    }
    var currentIndex: Int!
    
    required init(view: MainViewProtocol, compactPlayer: CompactPlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.view = view
        self.networkservice = networkService
        self.router = router
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
                    self.getImageResponce(responce: self.searchResponce?.results)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
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
    func dismissPlayer() {
        router?.dismissMusicPlayer()
    }
    
    func showCompactPlayer() {
        compactPlayerView?.showPlayerView()
    }
    
    func hideCompsctPlayer() {
        compactPlayerView?.hidePlayerView()
    }
    func setupCompactPlayer(trackIndex: Int) {
        compactPlayerView?.setupValues(index: trackIndex)
    }
    
    func tapOnThePlayer() {
        let data = MusicData(tracks: favoriteTracks, images: images)
        router?.presentMusicPlauer(data: data)
    }
    
    func addTrackInFavorite(track: Track) {
        self.favoriteTracks.append(track)
        userDefaults.save(favoriteTracks, forKey: "myTracks")
        print(self.favoriteTracks.count)
    }
    func removeTrackInFavorite(index: Int) {
        self.favoriteTracks.remove(at: index)
        userDefaults.save(self.favoriteTracks, forKey: "myTracks")
        print(self.favoriteTracks.count)
        if self.favoriteTracks.count == 0 {
            hideCompsctPlayer()
        }
    }
    
}
