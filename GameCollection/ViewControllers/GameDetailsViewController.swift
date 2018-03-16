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

    var game: Game?
    var storedPlatforms: [Int] = []
    var canAddPlatforms: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.platformsTableView.dataSource = self
        self.platformsTableView.delegate = self
        
        
        self.configureTitleView(title: self.game!.title)
        
        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if let game = Game.fetchWith(guid: self.game!.guid, context: context) {
            
            for platform in game.platforms {
                self.storedPlatforms.append(platform.id)
            }
            
        }
        
        
        if let image = self.game?.boxartImage {
            self.boxartView.image = image
        } else {
            if let url = URL(string: self.game!.boxart) {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {

                        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        
                        if let downloadedImage = UIImage(data: data) {
                            self.game?.save(image: downloadedImage, to: context)
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
            
        
        self.boxartView.contentMode = .scaleAspectFit
        if let date = self.game?.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"

            self.releaseDateLabel.text = "Released: \(dateFormatter.string(from: date))"
        } else {
            self.releaseDateLabel.text = ""
        }
        self.platformsTableView.reloadData()
    }
    
    private func configureTitleView(title: String) {
        
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
        
//        self.gameTitleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        self.gameTitleView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        self.navigationController?.navigationBar.addSubview(self.gameTitleView)
        

    
    }
    
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
        
        if let _ = storedPlatforms.first(where: { $0 == platform.id }) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.platformsTableView.cellForRow(at: indexPath)!
        
//        cell.isSelected = false
        self.platformsTableView.deselectRow(at: indexPath, animated: true)
        
        let platform = self.game!.platforms[indexPath.row]
        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if cell.accessoryType == .none {

            cell.accessoryType = .checkmark
            self.game!.insert(platform: platform, to: context)
            self.storedPlatforms.append(platform.id)

        } else if cell.accessoryType == .checkmark {

            cell.accessoryType = .none
            self.game!.remove(platform: platform, to: context)
            if let i = self.storedPlatforms.index(of: platform.id) {
                self.storedPlatforms.remove(at: i)
            }


        }
        
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Available on: "
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        guard let sectionTitle = self.tableView(tableView, titleForHeaderInSection: section) else {
//            return nil
//        }
//        
//        let label = UILabel()
//        label.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
//        label.backgroundColor = .clear
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.text = sectionTitle
//        
//        let view = UIView()
//        view.addSubview(label)
//        
//        return view
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
