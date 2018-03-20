//
//  FirstViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 14/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let gameGrabber = GameGrabber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.activityIndicator.isHidden = true
        
        // Configure SearchBar for the NavigationItem
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a game..."
        searchBar.showsScopeBar = true
        searchBar.returnKeyType = .search
        self.navigationItem.titleView = searchBar
        
        self.tableView.reloadData()
        
    }
    
    // MARK: - SearchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Clear TableView before searching
        self.gameGrabber.clear()
        self.tableView.reloadData()
        
        if let text = searchBar.text {
            searchBar.resignFirstResponder()
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.gameGrabber.searchForGamesWith(query: text) {
                error in
                
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
                // TODO: Alert if error?
            }
        }
    }
    
    // MARK: - TableView data source & delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameGrabber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GameSearchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let game = gameGrabber.list[indexPath.row]
        
        cell.textLabel?.text = game.title
        // List of platform abbreviations
        cell.detailTextLabel?.text = (game.platforms.flatMap({ platform -> String in
                                         return platform.abbreviation
                                     }) as Array).joined(separator: ", ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)!
        cell.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToGameSegue" {
            let gameViewController = segue.destination as! GameDetailsViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            gameViewController.game = self.gameGrabber.list[indexPath.row]
        }
    }
    

}

