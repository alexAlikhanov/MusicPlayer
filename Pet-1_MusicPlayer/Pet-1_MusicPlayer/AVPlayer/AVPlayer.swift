//
//  AVPlayer.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/28/22.
//

import Foundation
import AVFAudio

enum PlauerState{
    case play
    case pause
    case stop
}

protocol AVPlayerDataSouce: class {
    func avPlayer(_ AVPlayer: AVPlayer, sourse: Data) -> Data
}

protocol AVPlayerDelegate: class {
    func avPlayer(_ AVPlayer: AVPlayer, playerStateIs: PlauerState, currentItem : Int?)
}

protocol AVPlayerProtocol{
    var delegate: AVPlayerDelegate? { get set }
    var delegate2: AVPlayerDelegate? { get set }
    var currentItem: Int?{ get set }
    var isPlaying: Bool! { get set }
    func setup(data: Data?, currentItem: Int?)
    func play()
    func pause()
    func stop()
}
class AVPlayer: NSObject, AVPlayerProtocol {
    
    static var shared = AVPlayer()
    public weak var delegate: AVPlayerDelegate?
    public weak var delegate2: AVPlayerDelegate?
    public var currentItem: Int?
    public var isPlaying: Bool!
    private var player = AVAudioPlayer()
    
    func setup(data: Data?, currentItem: Int?){
        self.currentItem = currentItem
        guard let data = data else { return }
        do {
            self.player = try AVAudioPlayer(data: data, fileTypeHint: "m4a")
            self.player.delegate = self
            self.play()
        }
        catch {
            print("Error AVPlayer")
        }
    }
    func play() {
        player.play()
        isPlaying = true
        delegate?.avPlayer(self, playerStateIs: .play, currentItem: currentItem)
        delegate2?.avPlayer(self, playerStateIs: .play, currentItem: currentItem)
    }
    func stop() {
        player.stop()
        isPlaying = false
        delegate?.avPlayer(self, playerStateIs: .stop, currentItem: currentItem)
        delegate2?.avPlayer(self, playerStateIs: .stop, currentItem: currentItem)
    }
    func pause(){
        player.pause()
        isPlaying = false
        delegate?.avPlayer(self, playerStateIs: .pause, currentItem: currentItem)
        delegate2?.avPlayer(self, playerStateIs: .pause, currentItem: currentItem)
    }
}

extension AVPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        self.stop()
    }
}
