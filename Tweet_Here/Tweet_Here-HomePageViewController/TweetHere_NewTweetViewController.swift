//
//  TweetHere_NewTweetViewController.swift
//  Tweet_Here
//
//  Created by murugan on 28/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import MobileCoreServices
import TwitterKit


class TweetHere_NewTweetViewController: UIViewController {

    @IBOutlet weak var newTweetBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let alertController = UIAlertController(title: "Info", message: "Please select the tweet", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Picture/video", style: .default, handler: { (UIAlertAction) in
            
            self.presentImagePicker()

        }))
        
        alertController.addAction(UIAlertAction(title: "text", style: .default, handler: { (UIAlertAction) in
            
            // Swift
            if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
                // App must have at least one logged-in user to compose a Tweet
                let composer = TWTRComposerViewController.emptyComposer()
                composer.delegate = self
                self.present(composer, animated: true, completion: nil)
            } else {
                // Log in, and then check again
                TWTRTwitter.sharedInstance().logIn { session, error in
                    if session != nil { // Log in succeeded
                        let composer = TWTRComposerViewController.emptyComposer()
                        composer.delegate = self
                        self.present(composer, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                        self.present(alert, animated: false, completion: nil)
                    }
                }
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
            self.navigationController?.popViewController(animated: false)
            
        }))
        
        alertController.popoverPresentationController?.sourceRect = self.view.frame
        
        alertController.popoverPresentationController?.sourceView = self.view
        
        present(alertController, animated: true) {
            
            
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

    @IBAction func newTweetBtnAction(_ sender: Any) {
        
        presentImagePicker()
    }
}

extension TweetHere_NewTweetViewController {
    
    // MARK: Image Picker with TWTRComposerViewController
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(picker, animated: true, completion: nil)
    }
    
}

extension TweetHere_NewTweetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        self.navigationController?.popViewController(animated: false)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
        // Grab the relevant data from the image picker info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let fileURL = info[UIImagePickerControllerMediaURL] as? URL
        
        // Create the composer
        let composer = TWTRComposerViewController(initialText: "Check out this great image: ", image: image, videoURL:fileURL)
        composer.delegate = self
        present(composer, animated: true, completion: nil)
    }
}

extension TweetHere_NewTweetViewController : TWTRComposerViewControllerDelegate {
    
    
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        
        self.navigationController?.popViewController(animated: false)

    }
    
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        
        self.navigationController?.popViewController(animated: false)

    }
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        
        self.navigationController?.popViewController(animated: false)

    }
    
    
}

extension TweetHere_NewTweetViewController {
    
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
