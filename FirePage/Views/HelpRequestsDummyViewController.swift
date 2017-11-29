//
//  HelpRequestsDummyViewController.swift
//  FirePage
//
//  Created by Harshil Garg on 11/29/17.
//  Copyright © 2017 Theodore Franceschi. All rights reserved.
//

import UIKit

class HelpRequestsDummyViewController: UIViewController {

    @IBAction func navigateToHelpRequests(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "HelpRequests", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTableViewController") as! MainTableViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
