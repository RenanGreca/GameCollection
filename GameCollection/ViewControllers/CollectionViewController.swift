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
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var games: [String: [Game]]?
    
    var indexSections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionTableView.dataSource = self
        self.collectionTableView.delegate = self
        self.collectionTableView.tableFooterView = UIView()
        self.collectionTableView.sectionIndexColor = .green
        
//        self.activityIndicator.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let title = self.title,
            title == "Wishlist" {
            self.reload(with: .wishlist)
        } else {
            self.reload(with: nil)
        }

    }
    
    func reload(with status: Status?) {
//        self.activityIndicator.startAnimating()
        
        DispatchQueue.global().sync {
            
            if let status = status {
                self.games = Game.fetchAll(with: status)
            } else {
                self.games = Game.fetchAllInCollection()
            }
            
            self.indexSections = [String](self.games!.keys).sorted()
            
            DispatchQueue.main.async {
//                self.activityIndicator.isHidden = true
//                self.activityIndicator.stopAnimating()
                self.collectionTableView.reloadData()
            }
            
        }
    }
    
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
//        self.tableView(tableView, titleForHeaderInSection: section)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GameCollectionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let charIndex = self.indexSections[indexPath.section]
        
        if let game = self.games?[charIndex]?[indexPath.row] {
            cell.textLabel?.text = game.title
            cell.detailTextLabel?.text = (game.platforms.flatMap({ platform -> String in
                return platform.abbreviation
            }) as Array).joined(separator: ", ")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.collectionTableView.cellForRow(at: indexPath)!
        cell.isSelected = false
    }
    
    @IBAction func didTapFilterButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Filter", message: "Find games with status:", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "All", style: .default) {
            action in
            
            self.reload(with: nil)
        }
        alertController.addAction(action)
        
        for i in 0..<Status.count {
            let status = Status(rawValue: i)!
            
            if status == .notInCollection || status == .wishlist {
                continue
            }
            
            let action = UIAlertAction(title: status.string, style: .default) {
                action in
                self.reload(with: status)
            }
            alertController.addAction(action)
        }
        
        
        
        present(alertController, animated: true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionToGameSegue" {
            let gameViewController = segue.destination as! GameDetailsViewController
            let indexPath = self.collectionTableView.indexPath(for: sender as! UITableViewCell)!
            let charIndex = self.indexSections[indexPath.section]
            gameViewController.game = self.games?[charIndex]?[indexPath.row]
        }
    }

}

