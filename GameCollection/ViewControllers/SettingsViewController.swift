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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let reuseIdentifier = cell?.reuseIdentifier {
            switch (ReuseIdentifier(rawValue: reuseIdentifier)!) {
            case .deleteAllData:
                clearAllData()
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
