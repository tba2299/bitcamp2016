//
//  AlbumViewController.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AlbumViewController: UITableViewController, CLLocationManagerDelegate {
    // Init Location Manager
    let locationManager = CLLocationManager()
    
    // Variable to store the current location
    private var currentLocation: CLLocation!
    
    // Variable to store any errors with location
    private var locationError: NSError?
    
    // Store Album entries: value will be AlbumModel
    //let albumDictionary: [String: AlbumModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let albumCell = tableView.dequeueReusableCellWithIdentifier("AlbumViewCell")
        
        return albumCell
        
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let albumCell = tableView.dequeueReusableCellWithIdentifier("AlbumViewCell", forIndexPath: indexPath)
        
        return albumCell

    }
    
    
    /**************************************** LOCATION DELEGATE METHODS ******************************************/
    
    
    /**
     * Sets the currentLocation field to the user's current location. The user's current
     * location is the last recorded CLLocation object in the locations array being passed in.
     * Also resets the locationError field to nil.
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    /**
     * This is called when an error occurs while attempting to retrieve location information.
     * The error that is thrown is printed to the debugger and saved in the locationError
     * class field. The location manager stops updating the location once an error is thrown.
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        debugPrint("Location error occurred. ERROR: \(error)")
        locationError = error
        locationManager.stopUpdatingLocation()
    }
    
}