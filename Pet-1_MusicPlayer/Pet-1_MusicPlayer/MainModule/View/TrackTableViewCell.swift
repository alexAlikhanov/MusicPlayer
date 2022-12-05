//
//  TrackTableViewCell.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    public var presenter: MainViewPresenterProtocol!
    private var artworkImage: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var artistName: UILabel = {
        var label = UILabel()
        return label
    }()
    private var trackName: UILabel = {
        var label = UILabel()
        return label
    }()
    
    public var loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .yellow
        return indicator
    }()
    public var favoriteButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = nil
        button.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
        button.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .highlighted)
        return button
    }()
    
    private var state: Bool!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style , reuseIdentifier: "Cell")
        backgroundColor = nil
        contentView.addSubview(artistName)
        contentView.addSubview(trackName)
        contentView.addSubview(artworkImage)
        contentView.addSubview(loadIndicator)
        contentView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(sender:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        artistName.translatesAutoresizingMaskIntoConstraints = false
        artworkImage.translatesAutoresizingMaskIntoConstraints = false
        trackName.translatesAutoresizingMaskIntoConstraints = false
        loadIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artworkImage.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            artworkImage.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 5),
            artworkImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            artworkImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            artworkImage.widthAnchor.constraint(equalToConstant: contentView.safeAreaLayoutGuide.layoutFrame.size.height - 10)
        ])
        
        NSLayoutConstraint.activate([
            artistName.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            artistName.leftAnchor.constraint(equalTo: artworkImage.rightAnchor, constant: 10),
            artistName.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            trackName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 10),
            trackName.leftAnchor.constraint(equalTo: artworkImage.rightAnchor, constant: 10),
            trackName.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor.constraint(equalTo: artworkImage.centerXAnchor),
            loadIndicator.centerYAnchor.constraint(equalTo: artworkImage.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -15),
            favoriteButton.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
            favoriteButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        artworkImage.image = nil
        favoriteButton.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
        state = false
    }
    
    func create(track: Track?, presenter: MainViewPresenterProtocol, index: Int, state: Bool) {
        guard let track = track else { return }
        if let artistName = track.artistName {self.artistName.text = artistName}
        if let trackName = track.trackName {self.trackName.text = trackName}
        self.tag = index
        self.presenter = presenter
        self.state = state
        
        if self.state {
            favoriteButton.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
        }
    }
    func addImage(image: UIImage?){
        guard let image = image else { return }
        self.artworkImage.image = image
    }
    
    @objc func favoriteButtonAction(sender: UIButton){
        if !state {
            sender.setImage(UIImage(named:"favourite")?.withTintColor(.red), for: .normal)
            guard let track = presenter.searchResponce?.results[self.tag] else { return }
            presenter.addTrackInFavorite(track: track)
            state = true
        } else {
            sender.setImage(UIImage(named:"favourite (1)")?.withTintColor(.red), for: .normal)
            guard let track = presenter.searchResponce?.results[self.tag] else { return }
            presenter.removeTrackInFavorite(index: nil, id: track.trackId)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
