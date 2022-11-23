//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import Foundation

protocol PlayerViewProtocol: class{
    func setTrack(data: MusicData?)
}

protocol PlayerViewPresenterProtocol: class{
    init (view: PlayerViewProtocol, router: RouterProtocol, data: MusicData?)
    func setTrack()
    func back()
}


class PlayerPresenter: PlayerViewPresenterProtocol {
    weak var view: PlayerViewProtocol?
    var router: RouterProtocol?
    var data: MusicData?
    
    required init(view: PlayerViewProtocol, router: RouterProtocol, data: MusicData?) {
        self.view = view
        self.router = router
        self.data = data
    }
    
    func setTrack() {
        self.view?.setTrack(data: data)
    }
    
    func back() {
        router?.dismissMusicPlayer()
    }
}
