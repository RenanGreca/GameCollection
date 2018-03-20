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

        // Do any additional setup after loading the view.
    }
    
    private func confirmClear() {
        let alertController = UIAlertController(title: "Clear all data", message: "Are you sure you wish to delete all data from the app?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            action in
            
            clearAllData()
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(noAction)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
