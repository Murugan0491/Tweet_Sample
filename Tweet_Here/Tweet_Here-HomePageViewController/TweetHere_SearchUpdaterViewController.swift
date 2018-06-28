//
//  TweetHere_SearchUpdaterViewController.swift
//  Tweet_Here
//
//  Created by murugan on 29/06/18.
//  Copyright © 2018 murugan. All rights reserved.
//

import UIKit
import TwitterKit

class TweetHere_SearchUpdaterViewController: UIViewController {

    var tweetHere_HomePageViewControllerSearchUpdaterDelegate:TweetHere_HomePageViewControllerSearchUpdaterDelegate?
    
    var searcArr :[Any] = []
    
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

extension TweetHere_SearchUpdaterViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searcArr.count
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numOfSections: Int = 1
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "selectedItem.name"
//        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
        return cell
        
    }
    
}

extension TweetHere_SearchUpdaterViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)

    }
    
}

extension TweetHere_SearchUpdaterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print(searchController.searchBar.text as Any)
        
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
                    
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    //                    print("json: \(json)")
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    
                }
            }
            
            
        }
    }
    
}

