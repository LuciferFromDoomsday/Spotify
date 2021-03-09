//
//  SearchResult.swift
//  Spotify
//
//  Created by admin on 3/9/21.
//

import Foundation

enum SearchResult{
    
    case artist(model : Artist)
    case playlist(model : Playlist)
    case track(model : AudioTrack)
    case album(model : Album)
    
}
