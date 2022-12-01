//
//  MainVC + extantion TableView.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: return presenter.favoriteTracks.count
        case 1: return presenter.searchResponce?.resultCount ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
            cell.create(track: presenter.favoriteTracks[indexPath.row], presenter: self.presenter, index: indexPath.row)
            if presenter.images.count > indexPath.row {
                cell.addImage(image: presenter.images[indexPath.row])
                cell.favoriteButton.isHidden = true
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
            cell.create(track: presenter.searchResponce?.results[indexPath.row], presenter: self.presenter, index: indexPath.row)
            if presenter.imagesSearch.count > indexPath.row {
                cell.addImage(image: presenter.imagesSearch[indexPath.row])
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0:
            if !presenter.isCompactPlayerShow!{presenter.showCompactPlayer()}
            presenter.setupCompactPlayer(trackIndex: indexPath.row)
            presenter.currentIndex = indexPath.row
            
        case 1:
            guard let track = presenter.searchResponce?.results[indexPath.row] else { return }
            //presenter.addTrackInFavorite(track: track)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 0 { return true } else { return false }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.tag == 0 { return .delete } else { return .delete }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, tableView.tag == 0 {
            presenter.removeTrackInFavorite(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

