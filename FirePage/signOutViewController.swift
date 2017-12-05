import UIKit
import Firebase

class SignOutViewController: UIViewController{
    
    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        SessionInfo.logout(currentViewController: self)
    }
    
    
}

