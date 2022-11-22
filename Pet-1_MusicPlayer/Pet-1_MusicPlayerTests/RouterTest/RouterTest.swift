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
    
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testRouter(){
        router.presentMusicPlauer()
        let playerVC = navigationController.presentedVC
        XCTAssertTrue(playerVC is PlayerViewController)
    }

}