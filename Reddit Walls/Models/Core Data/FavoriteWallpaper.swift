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
    static let entityDescriptionName = "FavoriteWallpaper"
    
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var imageData: NSData?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteWallpaper> {
        return NSFetchRequest<FavoriteWallpaper>(entityName: FavoriteWallpaper.entityDescriptionName)
     }
}
