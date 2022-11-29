//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import Foundation

class PlayerPresenter: PlayerViewPresenterProtocol {
    weak var view: PlayerViewProtocol?
    var router: RouterProtocol?
    var data: MusicData?
    var player: AVPlayerProtocol?
    var networkService: NetworkServiceProtocol?
    required init(view: PlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, data: MusicData?, player: AVPlayerProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.data = data
        self.player = player
        self.player?.delegate2 = self
    }
    
    func getTrackResponce(responce: Track) {
        DispatchQueue.global().sync {
            networkService?.getTrackBy(urlString: responce.previewUrl, complition: {[weak self] (result) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.player?.setup(data: data, currentItem: self.data?.correntItem)
                    case .failure(let error):
                        print("error load track \(error)")
                        
                    }
                }
            })
        }
    }
    
    func setTrack() {
        self.view?.setTrack(data: data)
    }
    
    func back() {
        router?.dismissMusicPlayer()
    }
}

extension PlayerPresenter: AVPlayerDelegate {
    func avPlayer(_ AVPlayer: AVPlayer, playerStateIs: PlauerState, currentItem: Int?) {
        switch playerStateIs {
        case .play:
            self.view?.action(flag: true)
        case .pause:
            self.view?.action(flag: false)
        case .stop:
            self.view?.action(flag: false)
        }
    }
}
