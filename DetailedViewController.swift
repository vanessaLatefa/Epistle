//
//  DetailedViewController.swift
//  JournalApp
//
//  Created by Vanessa Latefa Pampilo on 5/15/19.
//  Copyright © 2019 Vanessa Latefa Pampilo. All rights reserved.
//

import UIKit
import Firebase


class DetailedViewController: UIViewController, UITextViewDelegate {
    
    var docRef: DocumentReference!

    
    @IBOutlet weak var texty: UITextView!
    
    var text: String = "Type your thoughts here.."
    var masterView: NoteTableViewController!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        texty.text = text
        docRef = Firestore.firestore().collection("epistle").document()
        
        
    }
    
    func setText(t:String){
        text = t
        if isViewLoaded{
            texty.text = t
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        masterView.newRowText = texty.text
        let notesToSave:[String:Any] = ["content": texty.text!]
        self.saveNotes(notesToSave: notesToSave)
    }
    
    func saveNotes(notesToSave:[String:Any]) {
       docRef.setData(notesToSave) {(error) in
            if let error = error {
                print("Shit error is here!: \(error.localizedDescription)")
            } else {
                print("Notes is on the database!")
            }
            
        }
    }

}
