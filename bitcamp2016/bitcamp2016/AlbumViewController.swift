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
import SwiftSpinner
import PullToRefresh

class AlbumViewController: UITableViewController, CLLocationManagerDelegate {
    // Init Location Manager
    let locationManager = CLLocationManager()
    
    // Variable to store the current location
    private var currentLocation: CLLocation!
    
    // Variable to store any errors with location
    private var locationError: NSError?
    
    // list of artists within current area
    var artistDataList: [Artist] = []
    
    // music metadata provider
    let musicMetadataProvider: MusicMetadataProvider = MusicMetadataProvider()
    
    // pull to refresh handler
    let pullToRefresher = PullToRefresh()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // set up notification so this view controller can be notified of data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reloadArtistData", object: nil)
    
        // set container view for spinner
        SwiftSpinner.useContainerView(self.view)
        
        // set up pull to refresh
        self.tableView.addPullToRefresh(self.pullToRefresher, action: {
            self.tableView.endRefreshing()
            SwiftSpinner.show("fetching artists...")
            self.musicMetadataProvider.getLocalArtistData(self)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // inform user of artist fetching
        SwiftSpinner.show("fetching artists...")
        
        // populate the artist data list with local artist information
        self.musicMetadataProvider.getLocalArtistData(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistDataList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentArtistCell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath) as! AlbumViewCell
        
        // set album cell fields
        currentArtistCell.albumCover.image = UIImage(named: "default_album_art.jpg")   // change to actual album cover
        currentArtistCell.bandName!.text = self.artistDataList[indexPath.item].name
                
        return currentArtistCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    /**
     * Used to reload table data from a notification.
     */
    func reloadTableData(notification: NSNotification?) {
        self.tableView.reloadData()
        SwiftSpinner.hide()
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