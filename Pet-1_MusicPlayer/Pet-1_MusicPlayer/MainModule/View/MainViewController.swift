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
        presenter.mainViewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConstraints()
    }
    
    private func setupConstraints(){
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchController.view.safeAreaLayoutGuide.topAnchor),
            searchTableView.centerXAnchor.constraint(equalTo: searchController.view.safeAreaLayoutGuide.centerXAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: searchController.view.safeAreaLayoutGuide.bottomAnchor),
            searchTableView.widthAnchor.constraint(equalToConstant: searchController.view.safeAreaLayoutGuide.layoutFrame.size.width)
        ])
        NSLayoutConstraint.activate([
            favoriteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favoriteTableView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width)
        ])
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
    func update() {
        favoriteTableView.reloadData()
    }
    
    func setupPlayingTrackLineInTable(index: Int) {
        let indePath = IndexPath(row: index, section: 0)
        self.favoriteTableView.selectRow(at: indePath, animated: true, scrollPosition: .none)
    }
    
    func changeIndicator(index: Int, state: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.favoriteTableView.cellForRow(at: indexPath) as? TrackTableViewCell else {return}
        if state {
            cell.loadIndicator.startAnimating()
        } else {
            cell.loadIndicator.stopAnimating()
        }
    }

    func sucsess() {
        searchTableView.reloadData()
        favoriteTableView.reloadData()
    }
    
    func failure(error: Error) {
        print("Fatal error: \(error)")
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
        
        presenter.getImageResponce(responce: presenter.favoriteTracks)
       
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        presenter.searchResponce = nil
        searchTableView.reloadData()
        if presenter.selectedArray == .search {
            presenter.hideCompsctPlayer()
        }
        return true
    }
}
