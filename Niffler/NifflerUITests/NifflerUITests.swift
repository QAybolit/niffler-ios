//
//  NifflerUITests.swift
//  NifflerUITests
//
//  Created by Dina Kholomkina on 29.08.2026.
//

import XCTest

final class NifflerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        launchAppWithoutLogin()
    }

    func test_login() throws {
        input(login: "stage", password: "12345")
        
        // Assert
        assertIsSpendsViewAppeared()
    }
    
    func test_createAccount() throws {
        tapCreateNewAccountButton()
        
        inputNewUsername(username: "Robert-2")
        inputNewPassword(password: "12345")
        confirmNewPassword(password: "12345")
        tapSignUpButton()
        
        assertRegistrationIsSuccess()
    }
    
    func test_saveEnteredData() throws {
        input(login: "Bob")
        input(password: "12345")
        tapCreateNewAccountButton()
        
        assertAllUsernameFieldValuesAreEquals(username: "Bob")
        assertAllPasswordFieldValuesDisplayEquals(password: "•••••")
        
    }
    
    func test_loginFailure() throws {
        input(login: "stage", password: "123456")
        
        assertIsErrorShown()
    }
    
    // MARK: - DSL (Domain Specific Language)
    private func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запускаю приложение в режиме 'Без авторизации'") { _ in
            app = XCUIApplication()
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
    private func input(login: String, password: String) {
        input(login: login)
        input(password: password)
        tapLoginButton()
    }
    
    private func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            app.textFields["userNameTextField"].tap()
            app.textFields["userNameTextField"].typeText(login)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            app.secureTextFields["passwordTextField"].tap()
            app.secureTextFields["passwordTextField"].typeText(password)
            app.secureTextFields["passwordTextField"].typeText(XCUIKeyboardKey.return.rawValue)
        }
    }
    
    private func tapLoginButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку логина") { _ in
            app.buttons["loginButton"].tap()
        }
    }
    
    private func tapCreateNewAccountButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку создания нового аккаунта") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    private func inputNewUsername(username: String) {
        XCTContext.runActivity(named: "Ввожу имя нового пользователя \(username)") { _ in
            let userNameField = app.textFields.matching(identifier: "userNameTextField").firstMatch
            userNameField.tap()
            userNameField.typeText(username)
        }
    }
    
    private func inputNewPassword(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль нового пользователя \(password)") { _ in
            let passwordField = app.secureTextFields.matching(identifier: "passwordTextField").firstMatch
            passwordField.tap()
            passwordField.typeText(password)
        }
    }
    
    private func confirmNewPassword(password: String) {
        XCTContext.runActivity(named: "Подтверждаю пароль нового пользователя \(password)") { _ in
            let confirmPasswordField = app.secureTextFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(password)
            confirmPasswordField.typeText(XCUIKeyboardKey.return.rawValue)
        }
    }
    
    private func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку регистрации") { _ in
            app.buttons["Sign Up"].tap()
        }
    }
    
    private func assertIsSpendsViewAppeared() {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            let _ = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    private func assertIsErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщения с ошибкой") { _ in
            let isFound = app.staticTexts["Нет такого пользователя. Попробуйте другие данные"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не нашли сообщение об ошибке",
                          file: file, line: line)
        }
    }
    
    private func assertRegistrationIsSuccess(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщения об успешной регистрации") { _ in
            let isFound = app.staticTexts["Congratulations!"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не появилось сообщение об успехе",
                          file: file, line: line
            )
            XCTAssertTrue(app.staticTexts[" You've registered!"].exists,
                          "Не появилось сообщение об успехе",
                          file: file, line: line
            )
        }
    }
    
    private func assertAllUsernameFieldValuesAreEquals(username: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что имя пользователя \(username) введено одинаково на странице логина и регистрации") { _ in
            let userNameFields = app.textFields.matching(identifier: "userNameTextField").allElementsBoundByIndex
            for field in userNameFields {
                let value = field.value as? String ?? ""
                XCTAssertEqual(value, username,
                               "Ожидаемое имя пользователя отличается от введенного",
                               file: file, line: line
                )
            }
        }
    }
    
    private func assertAllPasswordFieldValuesDisplayEquals(password: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что пароль \(password) отображается одинаково на странице логина и регистрации") { _ in
            let passwordFields = app.secureTextFields.matching(identifier: "passwordTextField").allElementsBoundByIndex
            
            for field in passwordFields {
                let value = field.value as? String ?? ""
                XCTAssertEqual(value, password,
                               "Ожидаемое отображение пароля отличается от введенного",
                               file: file, line: line
                )
            }
        }
    }
}
