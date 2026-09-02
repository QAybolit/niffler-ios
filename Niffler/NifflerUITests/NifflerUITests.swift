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
    
    func test_whenAddSpend_shouldShowSpendInList() throws {
        input(login: "stage", password: "12345")
        waitSpendsScreen()
        
        let title = UUID().uuidString
        
        addSpend()
        waitNewSpendsScreen()
        input(amount: "1000")
        input(description: title)
        waitSelectCategoryButton()
        tapSelectCategoryButton()
        selectCategory(name: "Покупки")
        createSpend()
        waitSpendsScreen()
        assertNewSpendIsDisplayed(spendName: title)
    }
    
    func test_whenCreateNewAccount_shouldBeEmptySpendList() throws {
        tapCreateNewAccountButton()
        inputNewUsername(username: "Robert-107")
        inputNewPassword(password: "12345")
        confirmNewPassword(password: "12345")
        tapSignUpButton()
        assertRegistrationIsSuccess()
        
        tapLoginButton()
        assertSpendsListIsEmpty()
    }
    
    func test_addFirstSpendForNewAccount() throws {
        tapCreateNewAccountButton()
        inputNewUsername(username: "Robert-106")
        inputNewPassword(password: "12345")
        confirmNewPassword(password: "12345")
        tapSignUpButton()
        assertRegistrationIsSuccess()
        
        tapLoginButton()
        assertSpendsListIsEmpty()
        
        let spend = UUID().uuidString
        let category = UUID().uuidString
        
        addSpend()
        waitNewSpendsScreen()
        input(amount: "1000")
        input(description: spend)
        waitSelectCategoryButton()
        tapSelectCategoryButton()
        addNewCategory(name: category)
        createSpend()
        waitSpendsScreen()
        assertNewSpendIsDisplayed(spendName: spend)
        assertNewCategoryIsDisplayed(category: category)
    }
    
    func test_whenNoCategoriesFound_createNewCategory() throws {
        input(login: "Robert-109", password: "12345")
        waitSpendsScreen()
        
        let spend = UUID().uuidString
        let category = "Покупки"
        
        if spendsCount() == 0 || !categoryIsExist(name: category) {
            addSpend()
            waitNewSpendsScreen()
            input(amount: "1000")
            input(description: spend)
            waitSelectCategoryButton()
            tapSelectCategoryButton()
            tapNewCategoryButton()
            addNewCategory(name: category)
            createSpend()
        } else {
            addSpend()
            waitNewSpendsScreen()
            input(amount: "1000")
            input(description: spend)
            waitSelectCategoryButton()
            tapSelectCategoryButton()
            selectCategory(name: category)
            createSpend()
        }
        waitSpendsScreen()
        assertNewSpendIsDisplayed(spendName: spend)
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
    
    // MARK: Login View
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
    
    // MARK: Registration View
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
    
    // MARK: Spend View
    private func addSpend() {
        XCTContext.runActivity(named: "Нажимаю кнопку 'Добавить трату'") { _ in
            app.buttons["addSpendButton"].tap()
        }
    }
    
    fileprivate func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            let isFound = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isFound,
                          "Не дождались экрана со списком трат",
                          file: file, line: line)
        }
    }
    
    private func assertIsSpendsViewAppeared() {
        XCTContext.runActivity(named: "Проверяю, что количество трат на экране больше 0") { _ in
            waitSpendsScreen()
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    private func assertNewSpendIsDisplayed(spendName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что новая трата \(spendName) отображается на странице трат") { _ in
            
            let isFound = app.scrollViews.staticTexts[spendName].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не нашли нужную трату на экране",
                          file: file, line: line
            )
        }
    }
    
    fileprivate func spendsCount() -> Int {
        return app.scrollViews.staticTexts.count
    }
    
    private func assertSpendsListIsEmpty(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что на странице трат не отображается ни одной траты") { _ in
            XCTAssertEqual(spendsCount(), 0,
                           "Список трат не пустой",
                           file: file, line: line)
        }
    }
    
    fileprivate func categoryIsExist(name: String) -> Bool {
        return app.scrollViews.staticTexts[name].waitForExistence(timeout: 5)
    }
    
    private func assertNewCategoryIsDisplayed(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что новая категория \(category) отображается на странице трат") { _ in
            
            let isFound = categoryIsExist(name: category)
            XCTAssertTrue(isFound,
                          "Не нашли нужную категорию на экране",
                          file: file, line: line
            )
        }
    }
    
    // MARK: New Spend View
    private func input(amount: String) {
        XCTContext.runActivity(named: "Ввожу размер траты \(amount)") { _ in
            app.textFields["amountField"].typeText(amount)
        }
    }
    
    private func input(description: String) {
        XCTContext.runActivity(named: "Ввожу описание траты \(description)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(description)
        }
    }
    
    private func tapSelectCategoryButton() {
        XCTContext.runActivity(named: "Нажимаю на кнопку выбора категории") { _ in
            app.buttons["Select category"].tap()
        }
    }
    
    private func selectCategory(name: String) {
        XCTContext.runActivity(named: "Выбираю категорию \(name)") { _ in
            app.buttons[name].tap()
        }
    }
    
    private func createSpend() {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания траты") { _ in
            app.buttons["Add"].tap()
        }
    }
    
    fileprivate func waitNewSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю экран создания новой траты") { _ in
            let isFound = app.staticTexts["New Spend"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались экрана создания новой траты",
                          file: file, line: line)
        }
    }
    
    fileprivate func waitSelectCategoryButton(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю кнопку выбора категории") { _ in
            let isFound = app.buttons["Select category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки выбора категории",
                          file: file, line: line)
        }
    }
    
    // MARK: Create New Category
    private func tapNewCategoryButton() {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания новой категории") { _ in
            app.buttons["+ New category"].tap()
        }
    }
    
    fileprivate func waitNewCategoryButton(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю кнопку создания новой категории") { _ in
            let isFound = app.buttons["+ New category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    fileprivate func waitAddCategoryWindow(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю окно создания новой категории") { _ in
            let isFound = app.staticTexts["Add category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались окна создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    private func addNewCategory(name: String) {
        XCTContext.runActivity(named: "Создаю новую категорию") { _ in
            waitAddCategoryWindow()
            app.textFields["Name"].typeText(name)
            app.buttons["Add"].firstMatch.tap()
        }
    }
}
