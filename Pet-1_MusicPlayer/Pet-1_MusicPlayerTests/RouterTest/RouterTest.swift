//
//  RouterTest.swift
//  Pet-1_MusicPlayerTests
//
//  Created by Алексей on 11/22/22.
//

import XCTest
@testable import Pet_1_MusicPlayer

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
class RouterTest: XCTestCase {

    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    var assembly = AssemblyModuleBuilder()
    var network = NetworkService()
    var player = AVPlayer()
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly, networkService: network, player: player)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testRouter(){
        let track = Track(artistName: "Foo", trackName: "foo", collectionName: "Baz", previewUrl: "Bar", artworkUrl100: "url", trackTimeMillis: 0)
        let tracks: [Track] = [track]
        let images = [UIImage()]
        var musicData = MusicData(tracks: tracks, images: images, isPlaying: true)
        router.presentMusicPlauer(data: musicData)
        let playerVC = navigationController.presentedVC
        XCTAssertTrue(playerVC is PlayerViewController)
    }

}
