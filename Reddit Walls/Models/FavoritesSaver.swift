//
//  FavoritesSaver.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/21/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import UIKit
import CoreData

protocol WallpaperInfoContaining: Codable, Equatable {
    var id: String { get set }
    var title: String { get set }
    var author: String { get set }
    var resolutions: Resolutions { get set }
    var favorite: Bool { get set }
}

protocol FavoritesSaving {
    // MARK: - Properties
    
    static var containerName: String { get }
    var container: NSPersistentContainer { get set }
    var context: NSManagedObjectContext { get set }
    
    // MARK: - Saving
    
    // TODO: Should this take in a completion to react to errors
    func store(_ image: UIImage, forWallpaper wallpaper: Wallpaper)
    
    // MARK: - Deleting
    
    // TODO: Should this take in a completion to react to errors
    func delete(wallpaper: Wallpaper)
}

class FavoritesSaver: FavoritesSaving {
    // MARK: Properties
    
    static var containerName: String {
        return "RedditWalls"
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: FavoritesSaver.containerName)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    
    lazy var context = container.viewContext
    
    // MARK: Saving
    
    func store(_ image: UIImage, forWallpaper wallpaper: Wallpaper) {
        guard let imageData = image.pngData() else {
            return
        }
        
//        let favoriteWallpaper = FavoriteWallpaper(context: context)
//        favoriteWallpaper.uid = wallpaper.id
//        favoriteWallpaper.imageData = imageData as NSData
        
        saveContext()
    }
    
    // MARK: Deleting
    
    func delete(wallpaper: Wallpaper) {
        let matchingWallpapers = findMatching(wallpaper: wallpaper)
        
        matchingWallpapers.forEach {  context.delete($0) }
        saveContext()
    }
    
    // MARK: Updating
    
    private func saveContext() {
        let context = container.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            assertionFailure("\(error.localizedDescription)")
        }
    }
    
    // MARK: Helpers
    
    private func findMatching(wallpaper: Wallpaper) -> [FavoriteWallpaper] {
        let request: NSFetchRequest<FavoriteWallpaper> = FavoriteWallpaper.fetchRequest()

        request.predicate = NSPredicate(format: "uid = %@", wallpaper.id)
        
        guard let matchingFavoriteWallpapers = try? context.fetch(request) else {
            return []
        }
        
        return matchingFavoriteWallpapers
    }
}
