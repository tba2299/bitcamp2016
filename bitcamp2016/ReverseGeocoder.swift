//
//  ReverseGeocoder.swift
//  bitcamp2016
//
//  Created by Tyler Askew on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SWXMLHash

class ReverseGeocoder: NSObject {

    // currently only uses the current city name, but does get a set of other nearby cities
    // that will be used to display music metadata about those if none exist in current city
    static func getNearbyCityNames(tableViewController: AlbumViewController) {
        var nearbyCityNames: Set<String> = Set<String>()
        
        // build request URL
        let requestUrl = "http://api.geonames.org/findNearbyPostalCodes?lat=\(tableViewController.currentLocation.coordinate.latitude.description)&lng=\(tableViewController.currentLocation.coordinate.longitude.description)&maxRows=10&username=tba2299"
        
        // make request to get names from geonames
        Alamofire.request(.GET, requestUrl).response { request, response, data, error in
            if data != nil {
                let xml = SWXMLHash.lazy(data!)
                var cityName: String!
                
                // used at the moment to get music metadata only off current city
                var closestCityName = xml["geonames"]["code"][0]["name"].element!.text!
                closestCityName = closestCityName.lowercaseString
                closestCityName = closestCityName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                // run through all artists returned and create models of them
                for city in xml["geonames"]["code"] {
                    cityName = city["name"].element!.text!
                    cityName = cityName.lowercaseString
                    cityName = cityName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    nearbyCityNames.insert(cityName)
                }
                
                // get metadata based on closest city
                MusicMetadataProvider.getLocalArtistData(tableViewController, cityName: closestCityName)
            } else {
                debugPrint("no data was returned from geonames")
            }
        }
    }
    
}
