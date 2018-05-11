//
//  RedditWallsUITests.swift
//  RedditWallsUITests
//
//  Created by Amanuel Ketebo on 5/7/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import XCTest

class SnapshotTest: XCTestCase {
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let app = XCUIApplication()

        for i in 0..<2 {
            snapshot("\(i)AllWallpapers")

            if i == 0 {
                let cellsQuery = app.collectionViews.cells
                cellsQuery.allElementsBoundByIndex[1].tap()
                snapshot("\(i)OneWallpaper")
                XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
            }

            app.staticTexts["FAVORITES"].tap()
            snapshot("\(i)Favorites")
            app.navigationBars["Favorites"].buttons["Back"].tap()
            app.navigationBars["Reddit Walls"].buttons["Item"].tap()
            app.children(matching: .window).tables.cells.firstMatch.switches.firstMatch.tap()
            app.navigationBars["Settings"].buttons["Done"].tap()
        }
    }
}
