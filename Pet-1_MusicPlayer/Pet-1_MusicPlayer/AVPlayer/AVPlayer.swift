//
//  AVPlayer.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/28/22.
//

import Foundation
import AVFAudio

enum PlayerState{
    case play
    case pause
    case stop
}

protocol AVPlayerDataSouce: class {
    func avPlayer(_ AVPlayer: AVPlayer, sourse: Data) -> Data
}

protocol AVPlayerDelegate: class {
    func avPlayer(_ AVPlayer: AVPlayer, playerStateIs: PlayerState, currentItem : Int?)
    func avPlayer(_ AVPlayer: AVPlayer, currentTime : TimeInterval?, durationTime: TimeInterval?)
}

protocol AVPlayerProtocol{

    var currentItem: Int?{ get set }
    var isPlaying: Bool! { get set }
    var currentTime: TimeInterval! { get set }
    var trackDuration: TimeInterval! { get set }
    func setup(data: Data?, currentItem: Int?)
    func setCurrentTime(time: TimeInterval)
    func play()
    func pause()
    func stop()
}
class AVPlayer: NSObject, AVPlayerProtocol {
    
    static var shared = AVPlayer()
    public var currentItem: Int?
    public var isPlaying: Bool!
    public var currentTime: TimeInterval!
    public var trackDuration: TimeInterval!
    private var player = AVAudioPlayer()
    private var timer = Timer()
    
    func setup(data: Data?, currentItem: Int?){
        self.currentItem = currentItem
        guard let data = data else { return }
        do {
            self.player = try AVAudioPlayer(data: data, fileTypeHint: "m4a")

            self.trackDuration = player.duration
            self.play()
        }
        catch {
            print("Error AVPlayer")
        }
    }
    func play() {
        player.play()
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            NotificationCenter.default.post(name: NSNotification.Name("AVPlayerTick"), object: (currentTime: self.player.currentTime, durationTime: self.player.duration ))
        })
        NotificationCenter.default.post(name: NSNotification.Name("AVPlayerState"), object: (playerStateIs: PlayerState.play, currentItem: currentItem))

    }
    func stop() {
        player.stop()
        isPlaying = false
        timer.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name("AVPlayerState"), object: (playerStateIs: PlayerState.stop, currentItem: currentItem))

    }
    func pause(){
        player.pause()
        timer.invalidate()
        isPlaying = false
        NotificationCenter.default.post(name: NSNotification.Name("AVPlayerState"), object: (playerStateIs: PlayerState.pause, currentItem: currentItem))

    }
    
    func setCurrentTime(time: TimeInterval) {
        player.pause()
        player.currentTime = time
        player.play()
    }
}

extension AVPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        self.stop()
    }
}
