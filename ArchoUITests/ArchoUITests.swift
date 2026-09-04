import XCTest

final class ArchoUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTabsArePresent() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Feed"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Generate"].exists)
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
    }

    @MainActor
    func testGenerateScreenShowsItsControls() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Generate"].tap()

        XCTAssertTrue(app.buttons["Reflection"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Generate 20 Posts"].exists)
    }
}
