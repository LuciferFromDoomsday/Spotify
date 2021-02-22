//
//  Playlist.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import Foundation
import UIKit

struct Playlist : Codable {
    let description : String
    let external_urls : [String: String]
    let id : String
    let images : [APIImage]
    let name : String
    let owner : User
    
}
