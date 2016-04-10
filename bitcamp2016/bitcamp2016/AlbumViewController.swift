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

class AlbumViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating {
    // Init Location Manager
    let locationManager = CLLocationManager()
    
    // Variable to store the current location
    var currentLocation: CLLocation!
    
    // Variable to store any errors with location
    private var locationError: NSError?
    
    // list of artists within current area
    var artistDataList: [Artist] = []

    private var filteredArtistDataList: [Artist] = []
    
    // search controller
    let searchListController = UISearchController(searchResultsController: nil)
    
    // pull to refresh handler
    let pullToRefresher = PullToRefresh()
    
    var selectedArtist: String?
    
    var selectedCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // set up notification so this view controller can be notified of data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reloadArtistData", object: nil)
        
        // set container view for spinner
        SwiftSpinner.useContainerView(self.view)
        
        // Enable user interaction
        view.userInteractionEnabled = true
        
        // request for location updates
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.currentLocation = locationManager.location
        }
        
        // set up search controller
        searchListController.searchResultsUpdater = self
        searchListController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchListController.searchBar
        searchListController.searchBar.barTintColor = UIColor.orangeColor()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationItem.hidesBackButton = true
        
        // used to close search on tap
        let closeSearch = UITapGestureRecognizer(target: self, action: "dismissSearch")
        //self.tableView.addGestureRecognizer(closeSearch)
        
        // set up pull to refresh
        self.tableView.addPullToRefresh(self.pullToRefresher, action: {
            self.tableView.endRefreshing()
            SwiftSpinner.show("fetching artists...")
            ReverseGeocoder.getNearbyCityNames(self)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // inform user of artist fetching
        SwiftSpinner.show("fetching artists...")
        
        // populate the artist data list with local artist information
        ReverseGeocoder.getNearbyCityNames(self)
    }
    
    // call filter function when user puts in search bar text
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterArtistListBySearch(searchController.searchBar.text!)
    }
    
    func dismissSearch() {
        self.searchListController.view.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchListController.active && searchListController.searchBar.text != "" {
            return filteredArtistDataList.count
        }
        
        return artistDataList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentArtistCell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath) as! AlbumViewCell
        var artist: Artist
        
        // determine if filtered or not
        if searchListController.active && searchListController.searchBar.text != "" {
            artist = filteredArtistDataList[indexPath.row]
        } else {
            artist = artistDataList[indexPath.row]
        }
        
        // set album cell fields
        currentArtistCell.albumCover.image = artist.albumCover!
        currentArtistCell.albumCover.clipsToBounds = true
        currentArtistCell.bandName!.text = artist.name
                
        return currentArtistCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) {
            self.selectedCell = selectedCell
            debugPrint("inside did select \(selectedArtist)")
            performSegueWithIdentifier("goToSongList", sender: selectedCell)
        }
    }
    
    /**
     * Used to reload table data from a notification.
     */
    func reloadTableData(notification: NSNotification?) {
        self.tableView.reloadData()
        SwiftSpinner.hide()
    }
    
    // used to filter the artist list
    func filterArtistListBySearch(searchText: String, scope: String = "All") {
        filteredArtistDataList = artistDataList.filter { artist in
            return artist.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    /* Overriding to pass artist data to vericationVC */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "goToSongList" { // Idenitify Segue
            let segueViewController = segue.destinationViewController as! SongViewController
            debugPrint("inside prepare \(selectedArtist)")
            let selectedCell = sender as! AlbumViewCell
            segueViewController.artist = selectedCell.bandName.text!
        }
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