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

    func testEqualWallpaper() {
        let title = "Car"
        let author = "carenthusiast"
        let fullResURLString = "https://www.cars.com/full"
        let lowerResURLString = "https://www.cars.com/lower"
        
        let firstResolution = Resolutions(fullResURLString: fullResURLString, lowResURLString: lowerResURLString)
        let secondResolution = Resolutions(fullResURLString: fullResURLString, lowResURLString: lowerResURLString)
        let thirdResolution = Resolutions(fullResURLString: fullResURLString, lowResURLString: lowerResURLString)
        
        let firstWallpaper = Wallpaper(title, author, firstResolution, favorite: false)
        let secondWallpaper = Wallpaper(title, author, secondResolution, favorite: false)
        let thirdWallpaper = Wallpaper("Random", author, thirdResolution, favorite: false)

        XCTAssertTrue(firstWallpaper == secondWallpaper)
        XCTAssertFalse(firstWallpaper == thirdWallpaper)
    }
}
