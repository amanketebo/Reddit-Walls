//
//  Wallpaper+CoreDataClass.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 8/21/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//
//

import Foundation
import CoreData


public class FavoriteWallpaper: NSManagedObject {
    @NSManaged public var uid: String?
    @NSManaged public var imageData: NSData?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteWallpaper> {
        return NSFetchRequest<Wallpaper>(entityName: "FavoriteWallpaper")
    }
}
