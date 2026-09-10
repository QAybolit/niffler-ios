import XCTest

final class LoginUITests: BaseTestCase {
    
    func test_login() throws {
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "stage", password: "12345")
        
        spendsPage
            .assertIsSpendsViewAppeared()
    }
    
    func test_createAccount() throws {
        
        launchAppWithoutLogin()
        loginPage
            .tapCreateNewAccountButton()
        
        registrationPage
            .input(username: "Robert-2", password: "12345")
            .tapSignUpButton()
            .assertRegistrationIsSuccess()
    }
    
    func test_saveEnteredData() throws {
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "Bob", password: "12345")
            .tapCreateNewAccountButton()
        
        registrationPage
            .assertAllUsernameFieldValuesAreEquals(username: "Bob")
            .assertAllPasswordFieldValuesDisplayEquals(password: "•••••")
        
    }
    
    func test_loginFailure() throws {
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "stage", password: "123456")
            .assertIsErrorShown()
    }

}
