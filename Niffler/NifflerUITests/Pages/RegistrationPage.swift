import XCTest

class RegistrationPage: BasePage {
    
    func input(username: String, password: String) -> Self {
        XCTContext.runActivity(named: "Ввожу имя нового пользователя \(username) и его пароль \(password)") { _ in
            inputNewUsername(username: username)
            inputNewPassword(password: password)
            confirmNewPassword(password: password)
        }
        return self
    }
    
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
    
    func tapSignUpButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю кнопку регистрации") { _ in
            app.buttons["Sign Up"].tap()
        }
        return self
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
    
    @discardableResult
    func assertAllUsernameFieldValuesAreEquals(username: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
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
        return self
    }
    
    @discardableResult
    func assertAllPasswordFieldValuesDisplayEquals(password: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
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
        return self
    }
}
