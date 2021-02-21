//
//  SettingsModels.swift
//  Spotify
//
//  Created by admin on 2/19/21.
//

import Foundation

struct Section {
    let Title : String
    let options : [Option]
}

struct Option {
    let title : String
    let handler : () -> Void
    
}
