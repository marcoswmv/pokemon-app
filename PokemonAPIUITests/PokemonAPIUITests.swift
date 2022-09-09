//
//  PokemonAPIUITests.swift
//  PokemonAPIUITests
//
//  Created by Marcos Vicente on 09/09/22.
//

import XCTest

class PokemonAPIUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testNavigationBar() throws {
        let app = XCUIApplication()
        app.launch()

        let navigationBarTitle = app.navigationBars["POKEMONS"]
        XCTAssertTrue(navigationBarTitle.exists, "Navigation bar not found")
    }

    func testSortDescending() throws {
        let app = XCUIApplication()
        app.launch()

        let sortButton = app.buttons["Sort by order"]
        XCTAssertTrue(sortButton.exists, "Sort button not found")

        sleep(2)
        sortButton.tap()
    }

    func testSortAscending() throws {
        let app = XCUIApplication()
        app.launch()

        let sortButton = app.buttons["Sort by order"]
        XCTAssertTrue(sortButton.exists, "Sort button not found")

        sleep(2)
        sortButton.tap()

        sleep(2)
        sortButton.tap()
    }

    func testNoSortButton() throws {
        let app = XCUIApplication()
        app.launch()

        let sortButton = app.buttons["Sort"]
        XCTAssertFalse(sortButton.exists, "Sort button found")
    }

    func testFavoritePokemon() throws {
        let app = XCUIApplication()
        app.launch()

        let tablesQuery = app.tables
        let bulbasaurCell = tablesQuery.cells.containing(.staticText, identifier:"BULBASAUR")
        XCTAssertTrue(bulbasaurCell.element.buttons["favorite"].exists, "Favorite button not found")

        bulbasaurCell.element.buttons["favorite"].tap()
        sleep(2)
    }

    func testNavigateToDetailScreen() throws {
        let app = XCUIApplication()
        app.launch()

        let tablesQuery = app.tables
        let bulbasaurCell = tablesQuery.cells.containing(.staticText, identifier:"BULBASAUR")
        XCTAssertTrue(bulbasaurCell.element.exists, "Cell not found")

        bulbasaurCell.element.tap()
        sleep(5)
    }
}
