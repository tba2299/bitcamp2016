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
    var albumCovers: [UIImage]?
    var artistDescription: String?
    
    init(name: String?, beginningArea: String?, type: String?, albumCovers: [UIImage]?, artistDescription: String?) {
        self.name = name
        self.beginningArea = beginningArea
        self.type = type
        self.albumCovers = albumCovers
        self.artistDescription = artistDescription
    }
    
    func toString() -> String {
        return "name=\(self.name), beginningArea=\(self.beginningArea), type=\(self.type)), albumCoversCount=\(self.albumCovers?.count), artistDescription=\(self.artistDescription)"
    }
    
}
