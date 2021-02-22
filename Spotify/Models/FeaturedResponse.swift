//
//  FeaturedResponse.swift
//  Spotify
//
//  Created by admin on 2/23/21.
//

import Foundation


struct FeaturedPlaylistsResponse : Codable {
    
    let playlists : PLaylistResponse
}


struct PLaylistResponse : Codable {
    let items : [Playlist]
    
}



struct User : Codable {
    let display_name : String
    let external_urls : [String: String]
    let id : String
    
}
