//
//  MainViewController.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import UIKit

class MainViewController: UIViewController {

    var presenter: MainViewPresenterProtocol!
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTableView: UITableView!
    private var favoriteTableView: UITableView!
    private var searchText = String()
    private var searchTimer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        createFavoriteTableView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "My music"
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.view.backgroundColor = .white
        createSearchTableView()
    }
    
    private func createSearchTableView(){
        searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        searchTableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "Cell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.separatorStyle = .none
        searchTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchTableView.tag = 1
        searchController.view.addSubview(searchTableView)
    }
    
    private func createFavoriteTableView(){
        favoriteTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        favoriteTableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "Cell")
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.separatorStyle = .none
        favoriteTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        favoriteTableView.tag = 0
        view.addSubview(favoriteTableView)
    }
}

extension MainViewController: MainViewProtocol{
    func sucsess() {
        searchTableView.reloadData()
    }
    
    func failure(error: Error) {
        print("Fatal error: \(error)")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0: return presenter.favoriteTracks.count
        case 1: return presenter.searchResponce?.resultCount ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
        switch tableView.tag {
        case 0: cell.create(track: presenter.favoriteTracks[indexPath.row])
        case 1: cell.create(track: presenter.searchResponce?.results[indexPath.row])
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 0:  print("tag 0")
        case 1:
            guard let track = presenter.searchResponce?.results[indexPath.row] else { return }
            presenter.addTrackInFavorite(track: track)
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

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = ""
        for char in searchText {
            if char == " " { self.searchText += "+"} else {
                self.searchText += String (char)
            }
        }
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
            self.presenter.getSearchResponce(request: self.searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchResponce = nil
        searchTableView.reloadData()
        favoriteTableView.reloadData()
    }
}
