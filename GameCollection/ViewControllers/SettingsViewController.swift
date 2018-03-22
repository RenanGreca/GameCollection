//
//  SettingsViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 14/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    enum ReuseIdentifier:String {
        case deleteAllData = "DeleteAllDataCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func confirmClear() {
        let alertController = UIAlertController(title: "Clear all data", message: "Are you sure you wish to delete all data from the app?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            action in
            
            Game.deleteAll()
            Platform.deleteAll()
//            Company.deleteAll()
        }
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (alertAction: UIAlertAction!) in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let reuseIdentifier = cell?.reuseIdentifier {
            switch (ReuseIdentifier(rawValue: reuseIdentifier)!) {
            case .deleteAllData:
                self.confirmClear()
            }
        }
    }

}
