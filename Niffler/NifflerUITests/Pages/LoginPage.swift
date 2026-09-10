import XCTest

class LoginPage: BasePage {
    
    @discardableResult
    func input(login: String, password: String) -> Self {
        XCTContext.runActivity(named: "Ввожу логин \(login) и пароль \(password)") { _ in
            input(login: login)
            input(password: password)
            tapLoginButton()
        }
        return self
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
    
    @discardableResult
    func tapLoginButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю кнопку логина") { _ in
            app.buttons["loginButton"].tap()
        }
        return self
    }
    
    @discardableResult
    func tapCreateNewAccountButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю кнопку создания нового аккаунта") { _ in
            app.staticTexts["Create new account"].tap()
        }
        return self
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
