//
//  ViewController.swift
//  Tweet_Here
//
//  Created by murugan on 26/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var tweetTRLogInButton: TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        let lastSession = store.session()
        
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let tweetHere_HomePageViewController: TweetHere_HomePageViewController = mainStoryboard.instantiateViewController(withIdentifier: "TweetHere_HomePageViewController") as! TweetHere_HomePageViewController
            
            self.navigationController?.pushViewController(tweetHere_HomePageViewController, animated: true);
            
        } else {
            
            tweetTRLogInButton = TWTRLogInButton(logInCompletion: { session, error in
                
                if (session != nil) {
                    
                    print("signed in as \(String(describing: session?.userName))");
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let tweetHere_HomePageViewController: TweetHere_HomePageViewController = mainStoryboard.instantiateViewController(withIdentifier: "TweetHere_HomePageViewController") as! TweetHere_HomePageViewController
                    
                    self.navigationController?.pushViewController(tweetHere_HomePageViewController, animated: true);
                    
                } else {
                    
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            })
            
            tweetTRLogInButton.center = self.view.center
            
            self.view.addSubview(tweetTRLogInButton)
            
        }
        
//        // Swift
//        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
//            if (session != nil) {
//                print("signed in as \(String(describing: session?.userName))");
//            } else {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        })
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController{
    
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
