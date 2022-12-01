//
//  SearchTableViewCell.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 12/1/22.
//

import Foundation


class SearchTableViewCell: TrackTableViewCell {

    override func create(track: Track?) {
        guard let track = track else { return }
        if let artistName = track.artistName {self.artistName.text = artistName}
        if let trackName = track.trackName {self.trackName.text = trackName}
    }
    override func addImage(image: UIImage?){
        guard let image = image else { return }
        self.artworkImage.image = image
    }
}
