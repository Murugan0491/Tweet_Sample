//
//  TweetHere_UserConfigurationViewController.swift
//  Tweet_Here
//
//  Created by murugan on 29/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import TwitterKit

class TweetHere_UserConfigurationViewController: UIViewController {
    @IBOutlet weak var tweetProfileImage: UIImageView!
    
    @IBOutlet weak var tweetUserName: UIButton!
    
    @IBOutlet weak var logOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let twitterClient = TWTRAPIClient(userID: TWTRTwitter.sharedInstance().sessionStore.session()?.userID)

        twitterClient.loadUser(withID: (TWTRTwitter.sharedInstance().sessionStore.session()?.userID)!) { (user, error) in
            
            self.tweetUserName.setTitle(user?.name, for: .normal)
            
            
            do {
                let data = try Data.init(contentsOf: URL.init(string: (user?.profileImageLargeURL)!)!)
                
                self.tweetProfileImage.image = UIImage.init(data: data)
            }
            catch _ {
                // Error handling
            }
            
            print(user?.profileImageURL ?? "")
            
        }
        
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

    @IBAction func logOutBtnAction(_ sender: Any) {
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            
            //            store.logOutUserID(userID)
            
            let viewControllerArr = self.navigationController!.viewControllers
            
            for viewController in viewControllerArr {
                
                if viewController is TweetHere_HomePageViewController || viewController is TweetHere_UserConfigurationViewController {
                    
                    self.navigationController!.viewControllers.remove(at: self.navigationController!.viewControllers.index(of: viewController)!)

                }

            }
        }
    }
}

extension TweetHere_UserConfigurationViewController {
    
    override func viewWillAppear(_ animated: Bool) { // Called when the view is about to made visible. Default does nothing
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) { // Called when the view has been fully transitioned onto the screen. Default does nothing
        
    }
    
    override func viewWillDisappear(_ animated: Bool) { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) { // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
        
    }
}
