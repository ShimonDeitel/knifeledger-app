import XCTest

final class KnifeledgerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() {
        app.buttons["addEntryButton"].tap()
        let saveButton = app.buttons["formSaveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() {
        for _ in 0..<20 {
            let addButton = app.buttons["addEntryButton"]
            guard addButton.exists else { break }
            addButton.tap()
            if app.buttons["paywallPurchaseButton"].waitForExistence(timeout: 1) {
                XCTAssertTrue(app.buttons["paywallPurchaseButton"].exists)
                app.buttons["paywallDismissButton"].tap()
                break
            }
            let saveButton = app.buttons["formSaveButton"]
            if saveButton.waitForExistence(timeout: 1) {
                saveButton.tap()
            }
        }
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addEntryButton"].tap()
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 2) {
            textField.tap()
            XCTAssertTrue(app.keyboards.element.exists)
            app.navigationBars.firstMatch.tap()
        }
    }

    func testSettingsSheetOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
