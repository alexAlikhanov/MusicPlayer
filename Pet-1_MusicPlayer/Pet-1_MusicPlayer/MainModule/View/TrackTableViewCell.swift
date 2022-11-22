//
//  TrackTableViewCell.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style , reuseIdentifier: "Cell")
        backgroundColor = nil
        contentView.addSubview(artistName)
        contentView.addSubview(trackName)
        contentView.addSubview(artworkImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        artistName.translatesAutoresizingMaskIntoConstraints = false
        artworkImage.translatesAutoresizingMaskIntoConstraints = false
        trackName.translatesAutoresizingMaskIntoConstraints = false
        
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
            artistName.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            trackName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 10),
            trackName.leftAnchor.constraint(equalTo: artworkImage.rightAnchor, constant: 10),
            trackName.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -5)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func create(track: Track?) {
        guard let track = track else { return }
        if let artistName = track.artistName {self.artistName.text = artistName}
        if let trackName = track.trackName {self.trackName.text = trackName}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
