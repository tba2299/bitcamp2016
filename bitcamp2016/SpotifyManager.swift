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
    
    /* func getAlbumArtworkFromUriHelper(artistUri: NSURL, artist: Artist) {
        var albumImage: UIImage?
        var albumData = NSData()
        var albumRes = NSURLResponse()
        
        do {
            let albumRequest = try SPTArtist.createRequestForAlbumsByArtist(artistUri, ofType: SPTAlbumType.Album, withAccessToken: nil, market:nil)
            
            NSURLSession.sharedSession().dataTaskWithRequest(albumRequest, completionHandler: {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                
                if error == nil && data != nil && response != nil {
                    albumData = data!
                    albumRes = response!
                    do {
                        let listObj = try SPTListPage(fromData: albumData, withResponse: albumRes, expectingPartialChildren: true, rootObjectKey: nil)
                        
                        if let albumObj = listObj.items[0] as? SPTPartialAlbum {
                            let albumImageUrl = albumObj.largestCover.imageURL
                            albumImage = UIImage(data: NSData(contentsOfURL: albumImageUrl)!)
                            artist.albumCover = albumImage
                            self.artistCount++
                        }
                    } catch _ {
                        debugPrint("Error creating Album Obj")
                    }
                } else {
                    debugPrint("yo this shit is an error: \(error)")
                }
   
            }).resume()
            
        } catch _ {
            debugPrint("Error when creating Album Request")
        }
    }*/
    
}