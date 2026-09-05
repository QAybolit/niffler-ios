import XCTest

class Page {
    init(app: XCUIApplication) {
        self.app = app
    }
    
    let app: XCUIApplication
    
    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запускаю приложение в режиме 'Без авторизации'") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
}


class LoginPage: Page {
    
    func input(login: String, password: String) {
        input(login: login)
        input(password: password)
        tapLoginButton()
    }
    
    func input(login: String) {
        XCTContext.runActivity(named: "Ввожу логин \(login)") { _ in
            app.textFields["userNameTextField"].tap()
            app.textFields["userNameTextField"].typeText(login)
        }
    }
    
    func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            app.secureTextFields["passwordTextField"].tap()
            app.secureTextFields["passwordTextField"].typeText(password)
            app.secureTextFields["passwordTextField"].typeText(XCUIKeyboardKey.return.rawValue)
        }
    }
    
    func tapLoginButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку логина") { _ in
            app.buttons["loginButton"].tap()
        }
    }
    
    func tapCreateNewAccountButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку создания нового аккаунта") { _ in
            app.staticTexts["Create new account"].tap()
        }
    }
    
    func assertIsErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщения с ошибкой") { _ in
            let isFound = app.staticTexts["Нет такого пользователя. Попробуйте другие данные"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не нашли сообщение об ошибке",
                          file: file, line: line)
        }
    }
}


class RegistrationPage: Page {
    
    func inputNewUsername(username: String) {
        XCTContext.runActivity(named: "Ввожу имя нового пользователя \(username)") { _ in
            let userNameField = app.textFields.matching(identifier: "userNameTextField").firstMatch
            userNameField.tap()
            userNameField.typeText(username)
        }
    }
    
    func inputNewPassword(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль нового пользователя \(password)") { _ in
            let passwordField = app.secureTextFields.matching(identifier: "passwordTextField").firstMatch
            passwordField.tap()
            passwordField.typeText(password)
        }
    }
    
    func confirmNewPassword(password: String) {
        XCTContext.runActivity(named: "Подтверждаю пароль нового пользователя \(password)") { _ in
            let confirmPasswordField = app.secureTextFields["confirmPasswordTextField"]
            confirmPasswordField.tap()
            confirmPasswordField.typeText(password)
            confirmPasswordField.typeText(XCUIKeyboardKey.return.rawValue)
        }
    }
    
    func tapSignUpButton() {
        XCTContext.runActivity(named: "Нажимаю кнопку регистрации") { _ in
            app.buttons["Sign Up"].tap()
        }
    }
    
    func assertRegistrationIsSuccess(file: StaticString = #filePath, line: UInt = #line) {
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
    
    func assertAllUsernameFieldValuesAreEquals(username: String, file: StaticString = #filePath, line: UInt = #line) {
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
    
    func assertAllPasswordFieldValuesDisplayEquals(password: String, file: StaticString = #filePath, line: UInt = #line) {
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


class SpendsPage: Page {
    
    func tapMenuIcon() {
        XCTContext.runActivity(named: "Нажимаю на иконку меню") { _ in
            app.images["ic_menu"].tap()
        }
    }
    
    func tapProfileButton() {
        XCTContext.runActivity(named: "Нажимаю на кнопку профиля") { _ in
            app.buttons["Profile"].tap()
        }
    }
    
    func addSpend() {
        XCTContext.runActivity(named: "Нажимаю на кнопку 'Добавить трату'") { _ in
            app.buttons["addSpendButton"].tap()
        }
    }
    
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            let isFound = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isFound,
                          "Не дождались экрана со списком трат",
                          file: file, line: line)
        }
    }
    
    func waitMenu(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду отображения меню") { _ in
            let isFound = app.staticTexts["Menu"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались отображения меню",
                          file: file, line: line)
        }
    }
    
    func assertIsSpendsViewAppeared() {
        XCTContext.runActivity(named: "Проверяю, что количество трат на экране больше 0") { _ in
            waitSpendsScreen()
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    func assertNewSpendIsDisplayed(spendName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что новая трата \(spendName) отображается на странице трат") { _ in
            
            let isFound = app.scrollViews.staticTexts[spendName].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не нашли нужную трату на экране",
                          file: file, line: line
            )
        }
    }
    
    func spendsCount() -> Int {
        return app.scrollViews.staticTexts.count
    }
    
    func assertSpendsListIsEmpty(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что на странице трат не отображается ни одной траты") { _ in
            XCTAssertEqual(spendsCount(), 0,
                           "Список трат не пустой",
                           file: file, line: line)
        }
    }
    
    func categoryIsExist(name: String) -> Bool {
        return app.scrollViews.staticTexts[name].waitForExistence(timeout: 5)
    }
    
    func assertNewCategoryIsDisplayed(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что новая категория \(category) отображается на странице трат") { _ in
            
            let isFound = categoryIsExist(name: category)
            XCTAssertTrue(isFound,
                          "Не нашли нужную категорию на экране",
                          file: file, line: line
            )
        }
    }
}


class NewSpendPage: Page {
    
    func input(amount: String) {
        XCTContext.runActivity(named: "Ввожу размер траты \(amount)") { _ in
            app.textFields["amountField"].typeText(amount)
        }
    }
    
    func input(description: String) {
        XCTContext.runActivity(named: "Ввожу описание траты \(description)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(description)
        }
    }
    
    func tapSelectCategoryButton() {
        XCTContext.runActivity(named: "Нажимаю на кнопку выбора категории") { _ in
            app.buttons["Select category"].tap()
        }
    }
    
    func selectCategory(name: String) {
        XCTContext.runActivity(named: "Выбираю категорию \(name)") { _ in
            app.buttons[name].tap()
        }
    }
    
    func createSpend() {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания траты") { _ in
            app.buttons["Add"].tap()
        }
    }
    
    func waitNewSpendsScreen(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю экран создания новой траты") { _ in
            let isFound = app.staticTexts["New Spend"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались экрана создания новой траты",
                          file: file, line: line)
        }
    }
    
    func waitSelectCategoryButton(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю кнопку выбора категории") { _ in
            let isFound = app.buttons["Select category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки выбора категории",
                          file: file, line: line)
        }
    }
    
    func tapNewCategoryButton() {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания новой категории") { _ in
            app.buttons["+ New category"].tap()
        }
    }
    
    func waitNewCategoryButton(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю кнопку создания новой категории") { _ in
            let isFound = app.buttons["+ New category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    func waitAddCategoryWindow(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю окно создания новой категории") { _ in
            let isFound = app.staticTexts["Add category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались окна создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    func addNewCategory(name: String) {
        XCTContext.runActivity(named: "Создаю новую категорию") { _ in
            waitAddCategoryWindow()
            app.textFields["Name"].typeText(name)
            app.buttons["Add"].firstMatch.tap()
        }
    }
    
    func categoryIsNotExist(name: String) -> Bool {
        return app.collectionViews.cells.buttons[name].waitForNonExistence(timeout: 3)
    }
    
    func assertCategoryIsNotInList(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что переданная категория \(category) не отображается в списке категорий") { _ in
            
            let isNotFound = categoryIsNotExist(name: category)
            XCTAssertTrue(isNotFound,
                          "Нашли переданную категорию на экране",
                          file: file, line: line
            )
        }
    }
}


class ProfilePage: Page {
    
    func delete(category: String) {
        XCTContext.runActivity(named: "Удаляю свайпом категорию \(category) из списка") { _ in
            app.collectionViews.cells.staticTexts[category].swipeLeft()
            app.buttons["Delete"].tap()
        }
    }
    
    func closeProfileScreen() {
        XCTContext.runActivity(named: "Закрываю экран профиля") { _ in
            app.buttons["Close"].tap()
        }
    }
    
    func waitProfileScreen(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю экран профиля") { _ in
            let isFound = app.staticTexts["User info"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались экрана профиля",
                          file: file, line: line)
        }
    }
    
    func categoryIsNotExist(name: String) -> Bool {
        return app.collectionViews.cells.staticTexts[name].waitForNonExistence(timeout: 3)
    }
    
    func assertCategoryIsNotInList(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что переданная категория \(category) не отображается в списке категорий") { _ in
            
            let isNotFound = categoryIsNotExist(name: category)
            XCTAssertTrue(isNotFound,
                          "Нашли нужную категорию на экране",
                          file: file, line: line
            )
        }
    }
    
    func assertCategoryIsInList(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что переданная категория \(category) отображается в списке категорий") { _ in
            
            let isFound = !categoryIsNotExist(name: category)
            XCTAssertTrue(isFound,
                          "Не нашли нужную категорию на экране",
                          file: file, line: line
            )
        }
    }
    
}
