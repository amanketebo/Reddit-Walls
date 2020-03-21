//
//  WallpapersResponse.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/21/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import Foundation

class WallpapersResponse {
    let wallpapers: [Wallpaper]
    let nextPage: String?
    
    init(wallpapersAPIResponse: WallpapersAPIResponse) {
        self.wallpapers = wallpapersAPIResponse.data?.children?.compactMap {
            Wallpaper(wallpaperData: $0.data)
        }  ?? []
        self.nextPage = wallpapersAPIResponse.data?.after
    }
}
