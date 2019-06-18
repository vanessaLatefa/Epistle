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
    //since i connected my app to the Firebase, using their collections, I can then save my notes.
    //refers to a document location in a Firestore database in my firebase account
    var docRef: DocumentReference!

    
    @IBOutlet weak var texty: UITextView!
    
    var text: String = " " //the object that reads what the user types
    var masterView: NoteTableViewController!
    

    //shows the textview object
    //docref loads my database which is notes collection called epistle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        texty.text = text
        docRef = Firestore.firestore().collection("epistle").document() //creates caches refering to the collection epistle, and then generates a unique ID
        
        
    }
    
    //reads the textView object, once the user types
    func setText(t:String){
        text = t
        if isViewLoaded{
            texty.text = t
        }
    }
    
    //function that saves my the texts, if for some reason the user exits the app
    //this will also automatically save my notes to the database
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        masterView.newRowText = texty.text
        let notesToSave:[String:Any] = ["content": texty.text!]
        self.saveNotesToDatabase(notesToSave: notesToSave)
    }
    
    //saves my notes to the database
    func saveNotesToDatabase(notesToSave:[String:Any]) {
       docRef.setData(notesToSave) {(error) in
            if let error = error {
                print("Shit error is here!: \(error.localizedDescription)")
            } else {
                print("Notes is on the database!")
            }
            
        }
    }

}
