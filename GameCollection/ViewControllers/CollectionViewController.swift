//
//  SecondViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 14/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    var games: [String: [Game]]?
    var platform: Platform?
    
    var indexSections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionTableView.dataSource = self
        self.collectionTableView.delegate = self
        self.collectionTableView.tableFooterView = UIView()
        self.collectionTableView.sectionIndexColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // The same ViewController is used for different lists, since the displays are nearly the same.
        
        if let platform = self.platform {
            // In case it came from the platforms list
            self.navigationItem.leftBarButtonItem = nil
            self.reload(with: platform)
        } else if let title = self.title,
            title == "Wishlist" {
            // Wishlist
            self.reload(with: .wishlist)
        } else {
            // Collection
            self.reload(with: nil)
        }

    }
    
    private func reload(with status: Game.Status?) {
        // Reload information depending on chosen status.
        
        DispatchQueue.global().sync {
            
            let title:String
            if let status = status {
                self.games = Game.fetchAll(with: status)
                title = status.string
            } else {
                self.games = Game.fetchAllInCollection()
                title = "Collection"
            }
            
            // Gets first letters for alphabetical indexing
            self.indexSections = [String](self.games!.keys).sorted()
            
            DispatchQueue.main.async {
                self.collectionTableView.reloadData()
                self.navigationItem.title = title
            }
            
        }
    }
    
    private func reload(with platform: Platform) {
        // Reload information depending on chosen status.
        
        DispatchQueue.global().sync {
            
            self.games = Game.fetchAll(with: platform)
            let title = platform.name

            // Gets first letters for alphabetical indexing
            self.indexSections = [String](self.games!.keys).sorted()
            
            DispatchQueue.main.async {
                self.collectionTableView.reloadData()
                self.navigationItem.title = title
            }
            
        }
    }
    
    // MARK: - TableView data source & delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let charIndex = self.indexSections[section]
        
        if let games = self.games?[charIndex] {
            return games.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.indexSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.indexSections[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexSections
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Section titles are letters
        
        guard let sectionTitle = self.tableView(tableView, titleForHeaderInSection: section) else {
            return nil
        }
    
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        label.text = sectionTitle
        
        let view = UIView()
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let charIndex = self.indexSections[indexPath.section]
        if let game = self.games?[charIndex]?[indexPath.row] {

            var numberOfExtraLines:CGFloat = CGFloat(game.ownedPlatforms.count / 7)
            if game.ownedPlatforms.count % 7 == 0 {
                numberOfExtraLines -= 1
            }
            
            return 60.0 + (22.0 * numberOfExtraLines)
        }
        return 60.0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GameTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GameTableViewCell
        
        let charIndex = self.indexSections[indexPath.section]
        
        // List of platform abbreviations
        if let game = self.games?[charIndex]?[indexPath.row] {
            cell.gameTitle?.text = game.title
            cell.draw(ownedPlatforms: game.ownedPlatforms)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func didTapFilterButton(_ sender: UIBarButtonItem) {
        // Show filter options
        
        let alertController = UIAlertController(title: "Filter", message: "Find games with status:", preferredStyle: .actionSheet)
        
        // Fake "All" status to show everything (minus wishlist)
        let action = UIAlertAction(title: "All", style: .default) {
            action in
            
            self.reload(with: nil)
        }
        alertController.addAction(action)
        
        for i in 0..<Game.Status.count {
            let status = Game.Status(rawValue: i)!
            
            // These statuses are not filters
            if status == .notInCollection || status == .wishlist {
                continue
            }
            
            let action = UIAlertAction(title: status.string, style: .default) {
                action in
                self.reload(with: status)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "collectionToGameSegue" ||
            segue.identifier == "wishlistToGameSegue" {
            
            let gameViewController = segue.destination as! GameDetailsViewController
            let indexPath = self.collectionTableView.indexPath(for: sender as! UITableViewCell)!
            let charIndex = self.indexSections[indexPath.section]
            gameViewController.game = self.games?[charIndex]?[indexPath.row]
        }
    }

}

