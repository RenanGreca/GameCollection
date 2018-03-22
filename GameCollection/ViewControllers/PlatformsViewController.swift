//
//  PlatformsViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 22/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class PlatformsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var platforms: [Platform] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global().sync {
            
            self.platforms = Platform.fetchAllInCollection()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - TableView data source & delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return platforms.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PlatformTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlatformTableViewCell
        
        let platform = self.platforms[indexPath.row]
        
        cell.titleLabel.text = platform.name
        cell.gameCountLabel.text = "\(platform.games.count)"
        cell.draw(company: platform.company)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "platformToCollectionSegue" {
            
            let collectionViewController = segue.destination as! CollectionViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            collectionViewController.platform = self.platforms[indexPath.row]
        }
    }

}
