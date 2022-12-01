//
//  MainPresenterTest.swift
//  Pet-1_MusicPlayerTests
//
//  Created by Алексей on 11/22/22.
//

import XCTest
@testable import Pet_1_MusicPlayer

class MockView: MainViewProtocol {
    func changeIndicator(index: Int, state: Bool) {
        
    }
    
    func setupPlayingTrackLineInTable(index: Int) {
        
    }
    
    func sucsess() {
        
    }
    func failure(error: Error) {
        
    }
}

class MockCompactPlayer: CompactPlayerViewProtocol {
    var loadIndicator: LoadIndicator
    
    func changeButtonState(state: PlayerState) {
        
    }
    
    var isShow: Bool
    
    init(isShow: Bool){
        self.isShow = isShow
        self.loadIndicator = LoadIndicator()
    }
    
    func showPlayerView() {
        
    }
    
    func hidePlayerView() {
        
    }
    
    func setupValues(index: Int) {
        
    }
    
    
}
class MockNetworkService: NetworkServiceProtocol {

    var request: Data!
    var searchRequest: SearchResponse!
    var image: UIImage!
    init(){}
    
    convenience init(request: Data?, image: UIImage?){
        self.init()
        self.request = request
        self.image = image
    }
    convenience init(request: SearchResponse?, image: UIImage?){
        self.init()
        self.searchRequest = request
        self.image = image
    }
    
    func searchTracksBy(request: String, complition: @escaping (Result<SearchResponse?, Error>) -> Void) {
        if let request = self.searchRequest {
            complition(.success(request))
        }else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            complition(.failure(error))
        }
    }

    func getTrackBy(urlString: String?, complition: @escaping (Result<Data?, Error>) -> Void) {
        if let request = self.request {
            complition(.success(request))
        }else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            complition(.failure(error))
        }
    }
    
    func getImageBy(urlString: String?, complition: @escaping (Result<UIImage?, Error>) -> Void) {
        if let image = self.image {
            complition(.success(image))
        } else {
            let error = NSError(domain: "", code: 1, userInfo: nil)
            complition(.failure(error))
        }
    }
}

class MockUserDefaults: UserDefaultsManager {
    
}

class MainPresenterTest: XCTestCase {

    var view: MockView!
    var presenter: Presenter!
    var networkServise: NetworkServiceProtocol!
    var player : AVPlayerProtocol!
    var router: RouterProtocol!
    var searchResponce: SearchResponse!
    var compactPlayer: MockCompactPlayer!
    var userDefaults: MockUserDefaults!
    
    override func setUpWithError() throws {
        let nav = UINavigationController()
        let assembly = AssemblyModuleBuilder()
        let network = NetworkService()
        let player = AVPlayer()
        router = Router(navigationController: nav, assemblyBuilder: assembly, networkService: network, player: player)
    }

    override func tearDownWithError() throws {
        view = nil
        networkServise = nil
        presenter = nil
        router = nil
    }
    
    func testGetSuccsesSearchResponce() {
        let track = Track(artistName: "Foo", trackName: "foo", collectionName: "Baz", previewUrl: "Bar", artworkUrl100: "url", trackTimeMillis: 0)
        let tracks: [Track] = [track]
        
        let searchResponce = SearchResponse(resultCount: 2, results: tracks)
        self.searchResponce = searchResponce
        
        view = MockView()
        userDefaults = MockUserDefaults()
        compactPlayer = MockCompactPlayer(isShow: true)
        networkServise = MockNetworkService(request: searchResponce, image: UIImage())
        player = AVPlayer()
        presenter = Presenter(view: view, compactPlayer: compactPlayer, router: router, networkService: networkServise, player: player, userDefaultsManager: userDefaults)
        
        
        var catchResponce: SearchResponse?
        var catchImage: UIImage?
        
        networkServise.searchTracksBy(request: "") { result in
            switch result {
            case .success(let responce):
                catchResponce = responce
            case .failure(let error):
                print(error)
            }
        }
        
        networkServise.getImageBy(urlString: "") { result in
            switch result {
            case .success(let image):
                catchImage = image
            case .failure(let error):
                print("image error", error)
            }
        }
        
        XCTAssertNotEqual(searchResponce.resultCount, 0)
        XCTAssertNotEqual(searchResponce.results.count, 0)
        XCTAssertNotNil(catchImage)
    }

    func testGetFailureSearchResponce() {
        let track = Track(artistName: "Foo", trackName: "foo", collectionName: "Baz", previewUrl: "Bar", artworkUrl100: "url", trackTimeMillis: 0)
        let tracks: [Track] = [track]
        
        let searchResponce = SearchResponse(resultCount: 2, results: tracks)
        self.searchResponce = searchResponce
        
        view = MockView()
        userDefaults = MockUserDefaults()
        compactPlayer = MockCompactPlayer(isShow: true)
        networkServise = MockNetworkService()
        player = AVPlayer()
        
        presenter = Presenter(view: view, compactPlayer: compactPlayer, router: router, networkService: networkServise, player: player, userDefaultsManager: userDefaults)
        
        
        var catchError1: Error?
        var catchError2: Error?
        
        networkServise.searchTracksBy(request: "") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError1 = error
            }
        }
        
        networkServise.getImageBy(urlString: "") { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError2 = error
            }
        }
        
        XCTAssertNotNil(catchError1)
        XCTAssertNotNil(catchError2)
    }

}
