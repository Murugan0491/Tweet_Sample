//
//  TweetHere_HomePageViewController.swift
//  Tweet_Here
//
//  Created by murugan on 27/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import MobileCoreServices
import TwitterKit

class TweetHere_HomePageViewController: UIViewController {

    
    @IBOutlet weak var tweerUserNameBtn: UIButton!
    @IBOutlet weak var tweetNewBtn: UIButton!
    @IBOutlet weak var tweetRefreshBtn: UIButton!
    @IBOutlet weak var tweetLogOutBtn: UIButton!
    
    @IBOutlet weak var tweerHomeTimeLineTableView: UITableView!

    var tweets :[TWTRTweet] = []

    private let refreshWebView = UIRefreshControl()

    var searchController = UISearchController()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tweerUserNameBtn.setTitle("loading...", for: .normal)
        
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient()
            client.loadUser(withID: userID) { (user, error) -> Void in
                // handle the response or error
                
                self.tweerUserNameBtn.setTitle(user?.name ?? "", for: .normal)
                print(user?.name ?? "")
                print(user?.userID ?? "")

            }
        }
        
        self.tweerHomeTimeLineTableView.rowHeight = UITableViewAutomaticDimension
        
        self.tweerHomeTimeLineTableView.estimatedRowHeight = 111
        
        self.tweerHomeTimeLineTableView.delegate = self
        
        self.tweerHomeTimeLineTableView.dataSource = self
        
        self.tweerHomeTimeLineTableView.register(UINib.init(nibName: "TweeTHomeTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TweeTHomeTimeLineTableViewCellIdentifier")
        
        refreshWebView.tintColor = UIColor.red
        
        refreshWebView.addTarget(self, action: #selector(reFreshWebView), for: .valueChanged)
        
        refreshWebView.backgroundColor = UIColor.black
        
        self.tweerHomeTimeLineTableView.refreshControl = refreshWebView
        
        reFreshWebView()

        self.searchController = UISearchController(searchResultsController:  nil)
        

//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let tweetHere_SearchUpdaterViewController = mainStoryboard.instantiateViewController(withIdentifier: "TweetHere_SearchUpdaterViewController") as! TweetHere_SearchUpdaterViewController
//        
//        self.searchController = UISearchController(searchResultsController:  tweetHere_SearchUpdaterViewController)
        
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar .sizeToFit()
                
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.definesPresentationContext = true
        
//        self.tweerHomeTimeLineTableView.tableHeaderView = self.searchController.searchBar;

        
        /*
        if let twitterAccountId = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient()
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
//            let params = ["id": "20"]
            
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: nil, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("json: \(json)")
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        } else {
            // Not logged in
        }
        */
        
        /*
        // Swift
        let client = TWTRAPIClient()
        client.loadTweet(withID: "3000") { (tweet, error) in
            if let t = tweet {
                
                let tweetView : TWTRTweetView = TWTRTweetView.init(tweet: t, style: .regular)
                
                tweetView.frame = CGRect.init(x: 0, y: 60, width: self.view.frame.size.width, height: tweetView.frame.size.height)
                tweetView.showActionButtons = true

                tweetView.delegate = self
                
                // Set the theme directly
                tweetView.theme = .dark
                
                self.viewIfLoaded?.addSubview(tweetView)
                
            } else {
                print("Failed to load Tweet: \(String(describing: error?.localizedDescription))")
            }
        }
        
        */
    }

    @objc func reFreshWebView() {
        
        if let session = TWTRTwitter.sharedInstance().sessionStore.session() as? TWTRSession {
            let headerSigner = TWTROAuthSigning(authConfig: TWTRTwitter.sharedInstance().authConfig, authSession: session)
            // Get header parameters for request
            
            let authHeaders = headerSigner.oAuthEchoHeadersToVerifyCredentials()
            
            let client = TWTRAPIClient(userID: TWTRTwitter.sharedInstance().sessionStore.session()?.userID)
            
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json?count=200"

//            let statusesShowEndpoint = "https://api.twitter.com/1.1/trends/place.json?id=1"
            
//            let statusesShowEndpoint = "https://api.twitter.com/1.1/trends/available.json"

//            let params = ["id": "1"]
            
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: nil, error: &clientError)
            
            //            request.allHTTPHeaderFields = authHeaders as? [String : String]
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(String(describing: connectionError))")
                    self.refreshWebView.endRefreshing()

                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    self.tweets = TWTRTweet.tweets(withJSONArray: json as? [Any]) as! [TWTRTweet]
                    
                    self.tweerHomeTimeLineTableView.reloadData()
                    
                    self.refreshWebView.endRefreshing()
                    //                    print("json: \(json)")
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    self.refreshWebView.endRefreshing()

                }
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func tweetUserImageBtnAction(_ sender: Any) {
    }
    @IBAction func tweerUserNameBtnAction(_ sender: Any) {
    }
    @IBAction func tweetNewBtnAction(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tweetHere_NewTweetViewController: TweetHere_NewTweetViewController = mainStoryboard.instantiateViewController(withIdentifier: "TweetHere_NewTweetViewController") as! TweetHere_NewTweetViewController
        
        self.navigationController?.pushViewController(tweetHere_NewTweetViewController, animated: false);
        
        
//        presentImagePicker()
        return
        // Swift
        /*
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            let composer = TWTRComposerViewController.emptyComposer()
            composer.delegate = self
            present(composer, animated: true, completion: nil)
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
        */
        
        /*
        // Swift
        let composer = TWTRComposer()
        
        composer.setText("just setting up my Twitter Kit")
        composer.setImage(UIImage(named: "twitterkit"))
        
        composer.show(from: self.navigationController!) { (result) in
            
            // Called from a UIViewController

            if (result == .done) {
                print("Successfully composed Tweet")
            } else {
                print("Cancelled composing")
            }
        }
         */
        
    }
    @IBAction func tweetRefreshBtnAction(_ sender: Any) {
    }
    @IBAction func tweetLogOutBtnAction(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tweetHere_UserConfigurationViewController: TweetHere_UserConfigurationViewController = mainStoryboard.instantiateViewController(withIdentifier: "TweetHere_UserConfigurationViewController") as! TweetHere_UserConfigurationViewController
        
        self.navigationController?.pushViewController(tweetHere_UserConfigurationViewController, animated: false);
        
        
        /*
        let alertController = UIAlertController(title: "Info", message: "Please select the tweet", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "logout", style: .default, handler: { (UIAlertAction) in
            
            let store = TWTRTwitter.sharedInstance().sessionStore
            
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
                
                self.navigationController?.popViewController(animated: false)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
            
        }))
        
        alertController.popoverPresentationController?.sourceRect = self.view.frame
        
        alertController.popoverPresentationController?.sourceView = self.view
        
        present(alertController, animated: true) {
            
            
        }
        
        */
        
    }
    
    
    
}


extension TweetHere_HomePageViewController{
    
    override func viewWillAppear(_ animated: Bool) { // Called when the view is about to made visible. Default does nothing
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) { // Called when the view has been fully transitioned onto the screen. Default does nothing
        
    }
    
    override func viewWillDisappear(_ animated: Bool) { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) { // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
        
    }
}

extension TweetHere_HomePageViewController {
    
    // MARK: Image Picker with TWTRComposerViewController
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(picker, animated: true, completion: nil)
    }

}
extension TweetHere_HomePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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

extension TweetHere_HomePageViewController : TWTRComposerViewControllerDelegate {
    
    
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        
        
    }
    
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        
        
    }
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        
        
    }
    

}

extension TweetHere_HomePageViewController : TWTRTweetViewDelegate {
    
    func tweetView(_ tweetView: TWTRTweetView, didTap image: UIImage, with imageURL: URL) {
        
        self.navigationController?.navigationBar.isHidden = false
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: imageURL as URL))
        webViewController.view = webView
        self.navigationController!.pushViewController(webViewController, animated: true)
    }

    func tweetView(_ tweetView: TWTRTweetView, didTapVideoWith videoURL: URL) {
        
    }
    
    func tweetView(_ tweetView: TWTRTweetView, didTap url: URL) {
        self.navigationController?.navigationBar.isHidden = false

        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: url as URL))
        webViewController.view = webView
        self.navigationController!.pushViewController(webViewController, animated: true)
        
    }
    

    func tweetView(_ tweetView: TWTRTweetView, didTapProfileImageFor user: TWTRUser) {
        self.navigationController?.navigationBar.isHidden = false
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: user.profileURL as URL))
        webViewController.view = webView
        self.navigationController!.pushViewController(webViewController, animated: true)
    }

    
    func tweetView(_ tweetView: TWTRTweetView, didTap tweet: TWTRTweet) {
        
    }
    
    func tweetView(_ tweetView: TWTRTweetView, didChange newState: TWTRVideoPlaybackState) {
        
        switch newState {
        case .paused:
            print("Do something when video is paused")
        case .playing:
            print("Do something when video starts to play")
        case .completed:
            print("Do something when video play is completed")
        }
        
    }

    func tweetView(tweetView: TWTRTweetView, didSelectTweet tweet: TWTRTweet) {
        print("Tweet selected: \(tweet)")
    }
    
}

extension TweetHere_HomePageViewController : UISearchControllerDelegate {

    
}

extension TweetHere_HomePageViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        print(searchController.searchBar.text ?? "")
    }
 
}


extension TweetHere_HomePageViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numOfSections: Int = 1
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweeTHomeTimeLineTableViewCellIdentifier", for: indexPath) as! TweeTHomeTimeLineTableViewCell
        
        cell.tweetView.configure(with: tweets[indexPath.row])
        
        cell.tweetView.showActionButtons = true
        
        cell.tweetView.delegate = self
        
        // Set the theme directly
        cell.tweetView.theme = .light
        
        return cell
        
    }
    
}

extension TweetHere_HomePageViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
    }
    
}

protocol TweetHere_HomePageViewControllerSearchUpdaterDelegate {
    
    func didSelectTweetHere_SearchUpdaterViewController(withInfo info:Any) -> Void

}

