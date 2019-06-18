//
//  ProfileViewController.swift
//  JournalApp
//
//  Created by Vanessa Latefa Pampilo on 5/9/19.
//  Copyright © 2019 Vanessa Latefa Pampilo. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //returns the number of notes in the tableview object
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //returns my cell with its indexpath which is A list of indexes that together represent the path to a specific location in a tree of nested arrays.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    
    @IBOutlet weak var table: UITableView!
    var data:[String] = []
    
    var selectedRow: Int = -1
    var newRowText: String = ""
    var fileURL: URL! //a resource for my local file to store my notes in my local storage
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       table.dataSource = self //self because when called, represents itself
        table.delegate = self
        self.title = "Journal"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //#selector??
       let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
       self.navigationItem.rightBarButtonItem = addButton
       self.navigationItem.leftBarButtonItem = editButtonItem
        
        //A file manager object lets you examine the contents of the file system and make changes to it.
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        //appending a agiven path for my notes which is notes.txt
        fileURL = baseURL.appendingPathComponent("notes.txt")
        load()
    }
    
    //This method is called before the view controller's view is about to be added to a view hierarchy
    //shows my table notes, reloads the notes, and also saves my notes to an ordered collection
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1{
            return
        }
        data[selectedRow] = newRowText
        if newRowText == "" {
            data.remove ( at: selectedRow)
        }
        table.reloadData()//Reloads the rows and sections of the table view.
        save()
    }
    
    
//    @IBAction func addANote(_ sender: Any) {
//        let name: String = ""
//        data.insert(name, at: 0)
//        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
//        table.insertRows(at: [indexPath], with: .automatic)
//        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//
//        self.performSegue(withIdentifier: "detail", sender: nil)
//        save()
//    }
    
    @objc func addNote() {
        let name: String = ""
        data.insert(name, at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        save()
    }
    
    
    //sets my tableview object??
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    //when selected, segue to my detailview controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    //notifies the view controller that a segue is about to be performed
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView: DetailedViewController = segue.destination as! DetailedViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(t: data [selectedRow])
    
        
    }
    
    //saves my notes to an ordered collection
    func save(){
     
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURL)
        } catch  {
            print("error writing file")
        }
        
    }
    //loads my collection of notes
    func load(){
        if let loadedData:[String] = NSArray(contentsOf: fileURL) as? [String]{
            data = loadedData
            table.reloadData()
        }
    }
    
}
