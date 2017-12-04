//
//  ChatViewController.swift
//  FirePage
//
//  Created by Harshil Garg on 12/3/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit
import GrowingTextView
//import UITextView_Placeholder

class ChatViewController: UIViewController, GrowingTextViewDelegate {
    
    @IBOutlet weak var messageBox: GrowingTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageBox.delegate = self
        
        messageBox.textContainer.lineFragmentPadding = 0
        messageBox.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        // Label navigation item
        navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.07, alpha:1.0)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //let field = UITextField()
        //field.background = UIColor.green
        //view.addSubview(field)
        messageBox.placeHolder = "Write your message..."
        messageBox.layer.cornerRadius = 10.0
        messageBox.font = UIFont.systemFont(ofSize: (messageBox.font?.pointSize)!, weight: UIFont.Weight.semibold)
        messageBox.placeHolderColor = UIColor(white: 0.8, alpha: 1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
