//
//  WallpaperTests.swift
//  RedditWallsUnitTests
//
//  Created by Amanuel Ketebo on 5/11/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import XCTest
@testable import Reddit_Walls

class WallpaperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWallpaperDictionaryInit() {
        let firstWallpaperInfo = [Wallpaper.title: "Cat",
                                  Wallpaper.author: "catlover",
                                  Wallpaper.lowerResolutionURL: "https://www.yahoo.com",
                                  Wallpaper.fullResolutionURL: "https://www.google.com"]

        let secondWallpaperInfo = [Wallpaper.title: "Dog",
                                   Wallpaper.author: "doglover",
                                   Wallpaper.lowerResolutionURL: "",
                                   Wallpaper.fullResolutionURL: ""]

        let thirdWallpaperInfo = [Wallpaper.title: "Nba Player",
                                  Wallpaper.author: "nbafan",
                                  Wallpaper.lowerResolutionURL: "https://www.nba.com",
                                  Wallpaper.fullResolutionURL: ""]

        let fourthWallpaperInfo = [Wallpaper.title: "Sunset",
                                   Wallpaper.author: "nature",
                                   Wallpaper.lowerResolutionURL: "",
                                   Wallpaper.fullResolutionURL: "https://www.wallpapers.com"]

        let firstWallpaper = Wallpaper(firstWallpaperInfo, favorite: true)
        let secondWallpaper = Wallpaper(secondWallpaperInfo, favorite: true)
        let thirdWallpaper = Wallpaper(thirdWallpaperInfo, favorite: true)
        let fourthWallpaper = Wallpaper(fourthWallpaperInfo, favorite: true)

        XCTAssertNotNil(firstWallpaper)
        XCTAssertNil(secondWallpaper, "")
        XCTAssertNil(thirdWallpaper, "")
        XCTAssertNil(fourthWallpaper, "")
    }

    func testEqualWallpaper() {
        let title = "Car"
        let author = "carenthusiast"
        let lowerResolutionURL = "https://www.cars.com/lower"
        let fullResolutionURL = "https://www.cars.com/full"

        let firstWallpaper = Wallpaper(title, author, lowerResolutionURL, fullResolutionURL)
        let secondWallpaper = Wallpaper(title, author, lowerResolutionURL, fullResolutionURL)
        let thirdWallpaper = Wallpaper("Random", author, lowerResolutionURL, fullResolutionURL)

        XCTAssertTrue(firstWallpaper == secondWallpaper)
        XCTAssertFalse(firstWallpaper == thirdWallpaper)
    }
}
