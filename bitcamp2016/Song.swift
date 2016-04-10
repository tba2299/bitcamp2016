//
//  Song.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/10/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import Foundation

class Song: NSObject {
    
    var songName: String?
    var songUri: NSURL?
    
    init(songName: String?, songUri: NSURL?) {
        self.songName = songName
        self.songUri = songUri
    }
}
