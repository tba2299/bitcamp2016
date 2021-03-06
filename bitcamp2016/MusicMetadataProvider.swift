//
//  MusicMetadataProvider.swift
//  bitcamp2016
//
//  Created by Tyler Askew on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import UIKit
import CoreLocation
import SWXMLHash

/**
 * Provides the methods to interact the MusicBrainz and 
 * obtain music metadata based on provided filters.
 */
class MusicMetadataProvider: NSObject {
        
    /**
     * Retrieve data about artists that were born
     * in the current local area.
     */
    static func getLocalArtistData(tableViewController: AlbumViewController, cityName: String) {
        let urlString = "http://musicbrainz.org/ws/2/artist/?query=beginarea:\(cityName)&type:group&type:person"
        let dataUrl = NSURL(string: urlString)
        
        // used to store the artist data
        var artistData: [Artist]? = [Artist]()
        
        // grab xml data from music brainz and parse through data
        if dataUrl != nil {
            let dataRetrievalTask = NSURLSession.sharedSession().dataTaskWithURL(dataUrl!) { data, response, error in
                if error != nil {
                    debugPrint("There was an error with the data retrieval: \(error)")
                    return
                }

                if data != nil {
                    let xml = SWXMLHash.lazy(data!)
                    var newArtist: Artist

                    // run through all artists returned and create models of them
                    for artist in xml["metadata"]["artist-list"]["artist"] {
                        newArtist = Artist(name: artist["name"].element?.text, beginningArea: artist["begin-area"]["name"].element?.text, type: artist.element?.attributes["type"], albumCover: nil, artistDescription: nil)
                        artistData?.append(newArtist)
                    }

                    // reset artist data list
                    tableViewController.artistDataList = artistData!
                    
                    // get album artwork from Spotify
                    SpotifyManager().getArtistAlbumArtSpotifyUriLooper(tableViewController)
                }
            }

            dataRetrievalTask.resume()
        } else {
            debugPrint("Data URL creation returned nil")
            artistData = nil
        }
    }
    
}