//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        titleAnimation("⚡️FlashChat")
        titleLabel.text = K.appName
       
    }
    
    private func titleAnimation(_ title: String) {
        titleLabel.text = ""
        var index = 0.0;
        for letter in title {
            Timer.scheduledTimer(withTimeInterval: index, repeats: false) { (Timer) in
                self.titleLabel.text?.append(letter)
            }
            index += 0.1
        }
    }
}
