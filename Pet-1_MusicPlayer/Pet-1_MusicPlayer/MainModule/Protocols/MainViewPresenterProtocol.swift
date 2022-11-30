//
//  MainViewPresenterProtocol.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, compactPlayer: CompactPlayerViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol, player: AVPlayerProtocol, userDefaultsManager: UserDefaultsManagerProtocol)
    var searchResponce: SearchResponse? { get set }
    var favoriteTracks: [Track] { get set }
    var imagesSearch: [UIImage?] { get set }
    var images: [UIImage?] { get set }
    var isCompactPlayerShow: Bool? { get }
    var currentIndex: Int! { get set }
    func mainViewLoaded()
    func getSearchResponce(request: String)
    func getSearchImageResponce(responce: [Track]?)
    func getImageResponce(responce: [Track]?)
    func getTrackResponce(responce: Track)
    func addTrackInFavorite(track: Track)
    func removeTrackInFavorite(index: Int)
    func showCompactPlayer()
    func hideCompsctPlayer()
    func setupCompactPlayer(trackIndex: Int)
    func tapOnThePlayer()
    func dismissPlayer()
    func changePlayerState(state: PlayerState)
}
