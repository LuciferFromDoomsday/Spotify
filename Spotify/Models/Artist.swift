//
//  Artist.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import Foundation


struct Artist : Codable{
    let id : String
    let name : String
    let type : String
    let external_urls : [String : String]
}
