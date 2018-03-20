//
//  GameDetailsViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit
import CoreData

class GameDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var boxartView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var platformsTableView: UITableView!
    
    @IBOutlet weak var gameTitleView: GameTitleView!
    @IBOutlet weak var titleToTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var notesButton: UIBarButtonItem!
    
    var game: Game?
    var storedPlatforms: [Int] = []
    var isCollection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.platformsTableView.dataSource = self
        self.platformsTableView.delegate = self        
        
        // Check if game is already in collection
        if let game = Game.fetchWith(guid: self.game!.guid) {
            
            for platform in game.platforms {
                self.storedPlatforms.append(platform.id)
            }
            
            self.game?.status = game.status
        }
        
        // NavigationBar title changes according to game title
        self.configureTitleView(title: self.game!.title)
        
        
        // Load art from database or save it from the Internet
        self.boxartView.contentMode = .scaleAspectFit
        if let image = self.game?.boxartImage {
            self.boxartView.image = image
        } else {
            if let url = URL(string: self.game!.boxart) {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {
                        
                        if let downloadedImage = UIImage(data: data) {
                            self.game?.boxartImage = downloadedImage
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.boxartView.image = downloadedImage
                        } else {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.boxartView.image = #imageLiteral(resourceName: "questionMark")
                        }
                    }
                }.resume()
            }
        }
            
        // We only want the year
        if let date = self.game?.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"

            self.releaseDateLabel.text = "Released in \(dateFormatter.string(from: date))"
        } else {
            self.releaseDateLabel.text = ""
        }
        
        // Notes and status buttons are dynamic according to status
        self.updateButtons(status: self.game!.status)
    }
    
    private func configureTitleView(title: String) {
        // The display is a bit different depending on whether or not there's a colon in the title
        
        let gameTitleArray = title.split(separator: ":", maxSplits: 1)
        
        let firstTitle = String(describing: gameTitleArray.first!)
        
        if  gameTitleArray.count > 1,
            let secondTitle = gameTitleArray.last {
            let subtitle = String(describing: secondTitle).trimmingCharacters(in: CharacterSet.whitespaces)
            self.titleLabel.text = firstTitle+":"
            self.subtitleLabel.text = subtitle
        } else {
            self.titleToTop.constant = 12
            self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
            self.titleLabel.text = firstTitle
            self.subtitleLabel.text = ""
        }
        
        self.navigationItem.backBarButtonItem?.title = ""
        
    }
    
    // MARK: - TableView data source & delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let game = self.game {
            return game.platforms.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AvailablePlatformsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let platform = self.game!.platforms[indexPath.row]

        cell.textLabel?.text = platform.name
        cell.accessoryType = .none
        
        // If the game is already in the collection, check the related platforms
        if storedPlatforms.contains(where: { $0 == platform.id }) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.platformsTableView.cellForRow(at: indexPath)!
        
        self.platformsTableView.deselectRow(at: indexPath, animated: true)
        
        let platform = self.game!.platforms[indexPath.row]

        
        if cell.accessoryType == .none {
            // Game-Platform relationship is not in collection, add it

            cell.accessoryType = .checkmark
            self.game!.insert(platform: platform)
            self.storedPlatforms.append(platform.id)
            self.updateButtons(status: self.game!.status)

        } else if cell.accessoryType == .checkmark {
            // Game-Platform relationship is in collection, remove it

            cell.accessoryType = .none
            self.game!.remove(platform: platform)
            if let i = self.storedPlatforms.index(of: platform.id) {
                self.storedPlatforms.remove(at: i)
            }
            
            // If there are no more platforms, the game is no longer in the collection. (see Game.remove(platform:))
            if self.storedPlatforms.count == 0 {
                self.updateButtons(status: .notInCollection)
            }


        }
        
    }
    
    @IBAction func didTapStatusButton(_ sender: UIButton) {
        // Show status options
        
        let alertController = UIAlertController(title: "Select status", message: "What is this game's current status?", preferredStyle: .actionSheet)
        
        for i in 0..<Status.count {
            let status = Status(rawValue: i)!
            
            let action = UIAlertAction(title: status.string, style: .default) {
                action in
                self.game?.status = status
                
                DispatchQueue.main.async {
                    self.updateButtons(status: status)
                }
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
    
    private func updateButtons(status: Status) {
        let isCollection = (status != .notInCollection)
        self.isCollection = isCollection
        self.notesButton.isEnabled = isCollection
        self.statusButton.isEnabled = isCollection
        self.statusButton.setTitle(status.string, for: UIControlState.normal)
        
        self.platformsTableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameToNotesSegue" {
            let notesViewController = segue.destination as! GameNotesViewController
            notesViewController.game = self.game
        }
    }

}
