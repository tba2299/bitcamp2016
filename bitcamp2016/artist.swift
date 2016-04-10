//
//  Artist.swift
//  bitcamp2016
//
//  Created by Tyler Askew on 4/9/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import UIKit

/**
 * Holds artist metadata.
 */
class Artist: NSObject {

    var name: String?
    var beginningArea: String?
    var type: String?
    var albumCover: UIImage?
    var artistDescription: String?
    
    init(name: String?, beginningArea: String?, type: String?, albumCover: UIImage?, artistDescription: String?) {
        self.name = name
        self.beginningArea = beginningArea
        self.type = type
        self.artistDescription = artistDescription
        
        if albumCover == nil {
            self.albumCover = UIImage(named: "default_album_art.jpg")
        } else {
            self.albumCover = albumCover
        }
    }
    
    func toString() -> String {
        return "name=\(self.name), beginningArea=\(self.beginningArea), type=\(self.type)), artistDescription=\(self.artistDescription)"
    }
    
}
