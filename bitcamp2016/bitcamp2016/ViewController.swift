//
//  ViewController.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/8/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    static let auth = SPTAuth.defaultInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        ViewController.auth.clientID = "ce2383b32d8442a28f406ad2acdf747b"
        ViewController.auth.redirectURL = NSURL(string: "bitcamp2016-spotify-login://returnafterlogin")!
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        let loginURL: NSURL = SPTAuth.defaultInstance().loginURL
        UIApplication.sharedApplication().performSelector(#selector(UIApplication.openURL(_:)), withObject: loginURL, afterDelay: 0.1)
        performSegueWithIdentifier("showArtists", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

