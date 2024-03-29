//
//  PlayerView.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/23/22.
//

import UIKit

class CompactPlayerView: UIView {
    
    static let shared = CompactPlayerView()
    var presenter: MainViewPresenterProtocol!
    var isShowed: Bool = false
    var yConstraint: NSLayoutConstraint!
    private var buttonState: Bool!
    
    private let closeButton: UIButton = {
        var butt = UIButton()
        butt.setImage(UIImage(named: "cancel"), for: .normal)
        butt.translatesAutoresizingMaskIntoConstraints = false
        return butt
    }()
    
    private let playPauseButton: UIButton = {
        var butt = UIButton()
        butt.setImage(UIImage(named: "play"), for: .normal)
        butt.translatesAutoresizingMaskIntoConstraints = false
        return butt
    }()
    
    private let artistNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "artist name"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let trackNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "track name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public var favoriteButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = nil
        button.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
        button.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .highlighted)
        return button
    }()
    
    public var loadIndicator = LoadIndicator.shared
    private var state: Bool!
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10
        self.addSubview(artistNameLabel)
        self.addSubview(trackNameLabel)
        self.addSubview(closeButton)
        self.addSubview(playPauseButton)
        self.addSubview(loadIndicator)
        self.addSubview(favoriteButton)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(gest:))))
        self.closeButton.addTarget(self, action: #selector(tapCencelButton(butt:)), for: .touchUpInside)
        self.playPauseButton.addTarget(self, action: #selector(playPauseButtonAction(sender:)), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(sender:)), for: .touchUpInside)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(self)

        if let  layoutGuide  = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.layoutMarginsGuide{
            yConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: layoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: 50),
                yConstraint,
                self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
            ])
                }
        
        closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playPauseButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        artistNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12).isActive = true
        artistNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/5).isActive = true

        trackNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        trackNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 3/5).isActive = true
        
        loadIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadIndicator.rightAnchor.constraint(equalTo: playPauseButton.leftAnchor, constant: -10).isActive = true
        loadIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.leftAnchor.constraint(equalTo: closeButton.rightAnchor, constant: 10).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true

        
        UIView.animate(withDuration: 0.5, animations: {
                   self.frame.origin.y = -150
                   self.artistNameLabel.frame.origin.y -= 150
                   self.trackNameLabel.frame.origin.y -= 150
        }, completion: { bool in
            if bool {
                self.isShowed = true
            } else {
                self.isShowed = false
            }
        })
    }
    @objc func favoriteButtonAction(sender: UIButton){
        
        if !state {
            sender.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .normal)
            let track = presenter.currentTracks[presenter.currentIndex]
            presenter.addTrackInFavorite(track: track)
            state = true
        } else {
            sender.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
            let track = presenter.currentTracks[presenter.currentIndex]
            presenter.removeTrackInFavorite(index: nil, id: track.trackId)
                state = false
        } 
    }
    
    @objc func tapCencelButton(butt: UIButton) {
        presenter.hideCompsctPlayer()
        presenter.dismissPlayer()
    }
    @objc func tap(gest: UITapGestureRecognizer) {
        presenter.tapOnThePlayer(forArray: presenter.selectedArray)
    }
    @objc func playPauseButtonAction(sender: UIButton) {
        if !buttonState {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            presenter.changePlayerState(state: .pause)
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            presenter.changePlayerState(state: .play)
        }
    }
}
extension CompactPlayerView : CompactPlayerViewProtocol {
    func changeButtonState(state: PlayerState) {
        switch state {
        case .play:
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.buttonState = false
        case .pause:
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.buttonState = true
        case .stop:
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.buttonState = false
        }
    }
    
    
    func hidePlayerView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.yConstraint.constant = 100
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.layoutIfNeeded()
        }, completion: { [weak self] bool in
            self?.removeFromSuperview()
            self?.isShowed = false
        })
    }
    
    func setupValues(forArray: MusicArray, index: Int, id: Int) {
        switch forArray {
        case .favorite:
            trackNameLabel.text = presenter.currentTracks[index].trackName
            artistNameLabel.text = presenter.currentTracks[index].artistName
        case .search:
            trackNameLabel.text = presenter.currentTracks[index].trackName
            artistNameLabel.text = presenter.currentTracks[index].artistName
        }
        print("id \(id) track id")
        if presenter.favoriteTracks.firstIndex(where: {$0.trackId == id }) != nil {
            favoriteButton.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .normal)
            state = true
        } else {
            favoriteButton.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
            state = false
        }
    }
    
    var isShow: Bool {
        return self.isShowed
    }
    
    func showPlayerView() {
        setup()
    }
}
