//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by admin on 3/9/21.
//

import Foundation


struct SearchResultResponse : Codable {
    
    let albums : SearchAlbumsResponse
    let artists : SearchArtistsResponse
    let tracks : SearchTracksResponse
    let playlists : SearchPlaylistsResponse
    
}

struct SearchAlbumsResponse : Codable {
    let items : [Album]
}
struct SearchPlaylistsResponse : Codable {
    let items : [Playlist]
}
struct SearchTracksResponse : Codable {
    let items : [AudioTrack]
}
struct SearchArtistsResponse : Codable {
    let items : [Artist]
}
