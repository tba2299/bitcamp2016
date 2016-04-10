//
//  SpotifyManager.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import Foundation


class SpotifyManager {
    
    func getArtistAlbumArtSpotifyUri(artist: String) -> UIImage? {
        var artistUri = NSURL()
        var albumImage: UIImage?
        
        // Search for given artist with spotify api
        SPTSearch.performSearchWithQuery(artist, queryType: SPTSearchQueryType.QueryTypeArtist, accessToken: nil, callback: {
            (error: NSError!, response: AnyObject!) -> Void in
            
                if error == nil {
                    let listPage = response as! SPTListPage
                    let artistObj = listPage.items[0] as! SPTPartialArtist
                    
                    artistUri = artistObj.uri
                    
                    albumImage = self.getAlbumArtworkFromUriHelper(artistUri)
                    
                    
                } else {
                    debugPrint("Error when performing search for Artist Query")
                }

        })
        
        return albumImage
    }
    
    func getAlbumArtworkFromUriHelper(artistUri: NSURL) -> UIImage? {
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
                            debugPrint(albumImage)
                        }
                    } catch _ {
                        debugPrint("Error creating Album Obj")
                    }
                } else {
                    debugPrint(error)
                }
                
            }).resume()
            
        } catch _ {
            debugPrint("Error when creating Album Request")
        }
        
        return albumImage
    }
    
}