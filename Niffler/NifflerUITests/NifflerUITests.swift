//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Dina Kholomkina on 29.08.2026.
//

import XCTest

final class NifflerUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["userNameTextField"].tap()
        app.textFields["userNameTextField"].typeText("stage")
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("12345")
        app.buttons["loginButton"].tap()
        
        let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
        XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        
    }
    
    func testCreateAccount() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Create new account"].tap()
        
        
        let userNameField = app.textFields.matching(identifier: "userNameTextField").firstMatch
        userNameField.tap()
        userNameField.typeText("Robert2")

        
        let passwordField = app.secureTextFields.matching(identifier: "passwordTextField").firstMatch
        passwordField.tap()
        passwordField.typeText("12345")
        
        let confirmPasswordField = app.secureTextFields["confirmPasswordTextField"]
        confirmPasswordField.tap()
        confirmPasswordField.typeText("12345")
        confirmPasswordField.typeText(XCUIKeyboardKey.return.rawValue)
        
        app.buttons["Sign Up"].tap()
        
        let _ = app.staticTexts["Congratulations!"].waitForExistence(timeout: 3)
        XCTAssertTrue(app.staticTexts["Congratulations!"].exists)
        XCTAssertTrue(app.staticTexts[" You've registered!"].exists)
        
    }
    
    func testSaveEnteredData() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["userNameTextField"].tap()
        app.textFields["userNameTextField"].typeText("Bob")
        app.secureTextFields["passwordTextField"].tap()
        app.secureTextFields["passwordTextField"].typeText("12345")
        app.secureTextFields["passwordTextField"].typeText(XCUIKeyboardKey.return.rawValue)
        
        app.staticTexts["Create new account"].tap()
        
        
        let userNameFields = app.textFields.matching(identifier: "userNameTextField").allElementsBoundByIndex
        
        let passwordFields = app.secureTextFields.matching(identifier: "passwordTextField").allElementsBoundByIndex
        
        for field in userNameFields {
            let value = field.value as? String ?? ""
            XCTAssertEqual(value, "Bob")
        }
        
        for field in passwordFields {
            let value = field.value as? String ?? ""
            XCTAssertEqual(value, "•••••")
        }
        
    }
}
