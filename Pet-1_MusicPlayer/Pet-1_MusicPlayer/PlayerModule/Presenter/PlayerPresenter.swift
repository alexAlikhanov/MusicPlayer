
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
    var currentTrackTime: Float?

    
    required init(view: PlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, data: MusicData?, player: AVPlayerProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.data = data
        self.player = player
        currentTrackTime = 0
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerTick(_:)), name: Notification.Name ("AVPlayerTick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerState(_:)), name: Notification.Name( "AVPlayerState"), object: nil)
    }
    
    func getTrackResponce(responce: Track) {
        self.player?.pause()
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
        view?.setTrack(data: data)
    }
    
    func back() {
        router?.dismissMusicPlayer()
    }
    
    func refrashData(currentTime: Float) {
        self.player?.setCurrentTime(time: TimeInterval(currentTime))
    }

    @objc func avPlayerState(_ notification: Notification) {
        let dataSet = notification.object as! (playerStateIs: PlayerState, currentItem: Int?)
        switch dataSet.playerStateIs {
        case .play:
            data?.correntItem = dataSet.currentItem
            view?.setupPlayingTrackLineInCollecrion(index: dataSet.currentItem!)
            view?.action(flag: true)
        case .pause:
            view?.action(flag: false)
        case .stop:
            view?.action(flag: false)
        }
    }
    @objc func avPlayerTick(_ notification: Notification) {
        let data = notification.object as! (currentTime: TimeInterval, durationTime: TimeInterval )

        view?.refrashSlider(currentTime: data.currentTime, duration: data.durationTime)
    }
 
}
