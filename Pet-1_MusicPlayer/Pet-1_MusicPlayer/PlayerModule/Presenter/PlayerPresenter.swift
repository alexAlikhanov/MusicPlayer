//
//  Presenter.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import Foundation

protocol PlayerViewProtocol: class{
    
}

protocol PlayerViewPresenterProtocol: class{
    init (view: PlayerViewProtocol, router: RouterProtocol)
    func back()
}


class PlayerPresenter: PlayerViewPresenterProtocol {
    weak var view: PlayerViewProtocol?
    var router: RouterProtocol?
    
    required init(view: PlayerViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func back() {
        router?.dismissMusicPlayer()
    }
}
