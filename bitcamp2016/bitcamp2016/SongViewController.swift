//
//  SongViewController.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/10/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import Foundation
import SwiftSpinner


class SongViewController: UITableViewController {
    var songArray: [SPTTrack] = []
    var artist: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up notification so this view controller can be notified of data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reloadSongData", object: nil)
        
        // set container view for spinner
        SwiftSpinner.useContainerView(self.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // inform user of artist fetching
        SwiftSpinner.show("fetching songs...")
        
        debugPrint(artist)
        // populate the Song data list with local artist information
        SpotifyManager().getTopTracksLooper(self, artist: artist)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentSongCell = tableView.dequeueReusableCellWithIdentifier("songCell", forIndexPath: indexPath) as! StreamSongCell
        currentSongCell.songLabel.text = songArray[indexPath.row].name
        
        return currentSongCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     * Used to reload table data from a notification.
     */
    func reloadTableData(notification: NSNotification?) {
        self.tableView.reloadData()
        SwiftSpinner.hide()
    }
    
}