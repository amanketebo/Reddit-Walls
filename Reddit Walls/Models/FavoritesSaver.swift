//
//  FavoritesSaver.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/21/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import UIKit
import CoreData

protocol FavoritesSaving {
    // MARK: - Properties
    
    static var containerName: String { get }
    var container: NSPersistentContainer { get set }
    var context: NSManagedObjectContext { get set }
    
    // MARK: - Saving
    
    func save(wallpaper: Wallpaper)
    // TODO: Should this take in a completion to react to errors
    func store(_ image: UIImage, forWallpaper wallpaper: Wallpaper)
    
    // MARK: - Deleting
    
    // TODO: Should this take in a completion to react to errors
    func delete(wallpaper: Wallpaper)
    
    // MARK: - Fetching
    
    func fetchFavorites() -> [FavoriteWallpaper]
    func fetchImage(forWallpaper wallpaper: Wallpaper) -> UIImage?
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
    
    func save(wallpaper: Wallpaper) {
        guard findMatching(wallpaper: wallpaper).isEmpty else {
            return
        }
        
        let favoriteWallpaper = FavoriteWallpaper(context: context)
        favoriteWallpaper.id = wallpaper.id
        favoriteWallpaper.title = wallpaper.title
        favoriteWallpaper.author = wallpaper.author
        saveContext()
    }
    
    func store(_ image: UIImage, forWallpaper wallpaper: Wallpaper) {
        guard let imageData = image.pngData() else {
            return
        }
        
        let previouslyStoredFavoriteWallpapers = findMatching(wallpaper: wallpaper)
        
        if previouslyStoredFavoriteWallpapers.isEmpty {
            let favoriteWallpaper = FavoriteWallpaper(context: context)
            favoriteWallpaper.id = wallpaper.id
            favoriteWallpaper.title = wallpaper.title
            favoriteWallpaper.author = wallpaper.author
            favoriteWallpaper.imageData = imageData as NSData
        } else {
            // TODO: (Aman Ketebo) Have a check here for if you have more than one favorite wallpaper
            previouslyStoredFavoriteWallpapers.first?.imageData = imageData as NSData
        }
        
        saveContext()
    }
    
    // MARK: Deleting
    
    func delete(wallpaper: Wallpaper) {
        let matchingWallpapers = findMatching(wallpaper: wallpaper)
        
        matchingWallpapers.forEach {  context.delete($0) }
        saveContext()
    }
    
    // MARK: - Fetching
    
    func fetchFavorites() -> [FavoriteWallpaper] {
        let allFavoriteWallpapersRequest: NSFetchRequest<FavoriteWallpaper> = FavoriteWallpaper.fetchRequest()
        
        guard let allFavoriteWallpapers = try? context.fetch(allFavoriteWallpapersRequest) else {
            return []
        }
        
        return allFavoriteWallpapers
    }
    
    func fetchImage(forWallpaper wallpaper: Wallpaper) -> UIImage? {
        let matchingFavoriteWallpapers = findMatching(wallpaper: wallpaper)
    
        guard !matchingFavoriteWallpapers.isEmpty,
            let imageData = matchingFavoriteWallpapers.first?.imageData else {
            return nil
        }
        
        return UIImage(data: imageData as Data)
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

        request.predicate = NSPredicate(format: "id = %@", wallpaper.id)
        
        guard let matchingFavoriteWallpapers = try? context.fetch(request) else {
            return []
        }
        
        return matchingFavoriteWallpapers
    }
}
