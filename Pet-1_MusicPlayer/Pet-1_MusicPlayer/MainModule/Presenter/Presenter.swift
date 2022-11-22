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

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol)
    var searchResponce: SearchResponse? { get set }
    var favoriteTracks: [Track] { get set }
    var images: [UIImage?] { get set }
    func getSearchResponce(request: String)
    func getImageResponce(responce: [Track]?)
    func addTrackInFavorite(track: Track)
    func removeTrackInFavorite(index: Int)
}

class Presenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var networkservice: NetworkServiceProtocol?
    var searchResponce: SearchResponse?
    var favoriteTracks: [Track] = []
    var images: [UIImage?] = []
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkservice = networkService
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
    
    func addTrackInFavorite(track: Track) {
        self.favoriteTracks.append(track)
    }
    func removeTrackInFavorite(index: Int) {
        self.favoriteTracks.remove(at: index)
    }
    
}
