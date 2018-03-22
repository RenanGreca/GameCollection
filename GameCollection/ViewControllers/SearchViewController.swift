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
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 60
        
        self.activityIndicator.isHidden = true
        
        // Configure SearchBar for the NavigationItem
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search for a game..."
        searchBar.showsScopeBar = true
        searchBar.returnKeyType = .search
        self.navigationItem.titleView = searchBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let game = gameGrabber.list[indexPath.row]

        var numberOfExtraLines:CGFloat = CGFloat(game.allPlatforms.count / 7)
        if game.allPlatforms.count % 7 == 0 {
            numberOfExtraLines -= 1
        }
        
        return 60.0 + (22.0 * numberOfExtraLines)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GameTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GameTableViewCell
        
        let game = gameGrabber.list[indexPath.row]
        
        cell.gameTitle?.text = game.title
        cell.draw(ownedPlatforms: game.ownedPlatforms, allPlatforms: game.allPlatforms)
//        cell.accessoryType = .disclosureIndicator
        
//        cell.textLabel?.text = game.title
        // List of platform abbreviations
//        cell.detailTextLabel?.text = (game.platforms.flatMap({ platform -> String in
//                                         return platform.abbreviation
//                                     }) as Array).joined(separator: ", ")
        
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

