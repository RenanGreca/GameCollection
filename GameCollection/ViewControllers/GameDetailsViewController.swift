//
//  GameDetailsViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 15/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var boxartView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var platformsTableView: UITableView!
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.platformsTableView.dataSource = self
        self.platformsTableView.delegate = self
        
        self.titleLabel.text = self.game?.title
//        self.boxartView.image = self.game?.boxart
        
        if let url = URL(string: self.game!.boxart) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
    //            print(response?.suggestedFilename ?? url.lastPathComponent)
                DispatchQueue.main.async() {
                    self.boxartView.image = UIImage(data: data)
                }
            }.resume()
        }
            
            
//            let urlData = try? Data(contentsOf: URL(string: boxartURL)!),
//            let image = UIImage(data: urlData) {

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available on: "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AvailablePlatformsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let game = self.game {
            cell.textLabel?.text = game.platforms[indexPath.row][Fields.title.rawValue]
        }
        
        /*
         
         if game is in library {
            cell.accessoryType = .checkmark
         }
         
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.platformsTableView.cellForRow(at: indexPath)!
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        cell.isSelected = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
