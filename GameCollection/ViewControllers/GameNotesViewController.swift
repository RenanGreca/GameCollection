//
//  GameNotesViewController.swift
//  GameCollection
//
//  Created by Cinq Technologies on 19/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit

class GameNotesViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var gameTitleView: GameTitleView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleToTop: NSLayoutConstraint!
    
    var game: Game?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTitleView(title: self.game!.title)
        
        self.textView.text = self.game!.notes
        
        if textView.text == "" ||
           textView.text == "Write notes about your progress, your thoughts on the game and anything else here." {
            textView.text = "Write notes about your progress, your thoughts on the game and anything else here."
            textView.textColor = .lightGray
        } else {
            textView.textColor = .white
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.game!.notes = self.textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write notes about your progress, your thoughts on the game and anything else here." {
            textView.text = ""
            textView.textColor = .white
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write notes about your progress, your thoughts on the game and anything else here."
            textView.textColor = .lightGray
        }
        
        textView.resignFirstResponder()
    }
    
    private func configureTitleView(title: String) {

        self.titleLabel.text = "Notes"
        self.subtitleLabel.text = title
        
        self.navigationItem.backBarButtonItem?.title = ""
 
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
