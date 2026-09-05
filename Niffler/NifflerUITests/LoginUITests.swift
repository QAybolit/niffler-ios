import XCTest

final class LoginUITests: TestCase {
    
    func test_login() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let spendPage = SpendsPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "stage", password: "12345")
        
        spendPage.assertIsSpendsViewAppeared()
    }
    
    func test_createAccount() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let registrationPage = RegistrationPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.tapCreateNewAccountButton()
        registrationPage.inputNewUsername(username: "Robert-2")
        registrationPage.inputNewPassword(password: "12345")
        registrationPage.confirmNewPassword(password: "12345")
        registrationPage.tapSignUpButton()
        
        registrationPage.assertRegistrationIsSuccess()
    }
    
    func test_saveEnteredData() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let registrationPage = RegistrationPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "Bob", password: "12345")
        loginPage.tapCreateNewAccountButton()
        
        registrationPage.assertAllUsernameFieldValuesAreEquals(username: "Bob")
        registrationPage.assertAllPasswordFieldValuesDisplayEquals(password: "•••••")
        
    }
    
    func test_loginFailure() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "stage", password: "123456")
        
        loginPage.assertIsErrorShown()
    }

}
