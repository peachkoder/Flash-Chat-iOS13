//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // toolbar title
        title = K.appName
        // hide back button
        navigationItem.hidesBackButton = true
        
        // register the table cell
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ] ) { error in
                if let e = error {
                    print("[Firestore saving data error] \(e)")
                } else {
                    self.messageTextfield.text = ""
                }
            }
            
        }
        
    }
    
    private func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField )
            .addSnapshotListener { snapShot, error in
            self.messages = [] // messages cleaning
            if let e = error {
                print("[Firestore getting messages error:] \(e)")
            } else {
                if let recordSet = snapShot?.documents {
                    for record in recordSet {
                        let data = record.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String {
                            let newMsg = Message(sender: sender, body: body)
                            self.messages.append(newMsg)
                            
                            // necessary in order to populate the messages and refresh the tableView
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            // go direct to root view
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Sign out Error: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text =  messages[indexPath.row].body
//        cell.backgroundColor =  UIColor.init(named: K.BrandColors.purple)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(cell)
    }

}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("fbfdb")
    
    }
}

