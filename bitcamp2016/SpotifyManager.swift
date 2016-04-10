//
//  SpotifyManager.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import Foundation


class SpotifyManager {
    var artistCount = 0
    var songCount = 0
    
    func getArtistAlbumArtSpotifyUri(artist: Artist) {
        
        // Search for given artist with spotify api
        SPTSearch.performSearchWithQuery(artist.name!, queryType: SPTSearchQueryType.QueryTypeArtist, accessToken: nil, callback: {
            (error: NSError?, response: AnyObject!) -> Void in

                if error == nil {
                    let listPage = response as! SPTListPage
                    var artistObj: SPTPartialArtist
                    
                    if listPage.items != nil && listPage.items.count > 0 {
                        artistObj = listPage.items[0] as! SPTPartialArtist
                        let artistUri = artistObj.uri
                        
                        SPTArtist.artistsWithURIs([artistUri], accessToken: nil, callback: {
                            (error: NSError?, response: AnyObject!) -> Void in
                            
                            if error == nil {
                                let sptArtist = response as! [SPTArtist]
                                if sptArtist.count > 0 {
                                    var imageData: NSData? = nil
                                    
                                    if sptArtist[0].largestImage != nil && sptArtist[0].largestImage.imageURL != nil {
                                        let imageUrl = sptArtist[0].largestImage.imageURL
                                        imageData = NSData(contentsOfURL: imageUrl)
                                    }
                                    
                                    if imageData != nil {
                                        let albumImage = UIImage(data: imageData!)
                                        artist.albumCover = (albumImage != nil) ? albumImage : artist.albumCover
                                    }
                                }
                            }
                        })
                    }
                    
                    self.artistCount++
                } else {
                    debugPrint("Error when performing search for Artist Query")
                }
        })
    }
    
    func getArtistAlbumArtSpotifyUriLooper(tableViewController: AlbumViewController) {
        for artist in tableViewController.artistDataList {
            getArtistAlbumArtSpotifyUri(artist)
        }
        
        while(artistCount != tableViewController.artistDataList.count) {
            // Wait until threads are finished
        }
        
        artistCount = 0
        // ArtistCount == size of Artist Array:
        // tell view controller to reload table data
        NSNotificationCenter.defaultCenter().postNotificationName("reloadArtistData", object: nil)
        
    }
    
    func getTopTracksLooper(tableViewController: SongViewController, artist: String?) {
        
        debugPrint("inside top track looper")
        getArtistSongsSpotifyUri(tableViewController, artist: artist)
        
        /*while(songCount < 1) {
            // Wait
        }*/
        
        songCount = 0
        //NSNotificationCenter.defaultCenter().postNotificationName("reloadSongData", object: nil)
    }
    
    func getArtistSongsSpotifyUri(tableViewController: SongViewController, artist: String?) {
        debugPrint("inside get songs")
        SPTSearch.performSearchWithQuery(artist, queryType: SPTSearchQueryType.QueryTypeArtist, accessToken: nil, callback: {
            (error: NSError!, response: AnyObject!) -> Void in
            debugPrint("inside callback")
            
            if error == nil {
                let listPage = response as! SPTListPage
                var artistObj: SPTPartialArtist
                
                if listPage.items != nil && listPage.items.count > 0 {
                    artistObj = listPage.items[0] as! SPTPartialArtist
                    let artistUri = artistObj.uri
                    
                    SPTArtist.artistsWithURIs([artistUri], accessToken: nil, callback: {
                        (error: NSError?, response: AnyObject!) -> Void in
                        
                        if error == nil {
                            let sptArtist = response as! [SPTArtist]
                            if sptArtist.count > 0 {
                                debugPrint("after sptArtists \(sptArtist[0])")
                                
                                sptArtist[0].requestTopTracksForTerritory("US", withAccessToken: nil, callback: {
                                    (error: NSError?, response: AnyObject!) -> Void in
                                    
                                    debugPrint("inside last callback")
                                    if error == nil {
                                        let topTracks = response as! [SPTTrack]
                                        debugPrint("unwrapped")
                                        if topTracks.count > 0 {
                                            tableViewController.songArray = topTracks
                                            self.songCount++
                                            NSNotificationCenter.defaultCenter().postNotificationName("reloadSongData", object: nil)
                                        }
                                    }
                                    
                                })
                            }
                        }
                    })
                }
                
                self.songCount++
            } else {
                debugPrint("Its not good if theres an error here")
            }
        })
    }
    
}