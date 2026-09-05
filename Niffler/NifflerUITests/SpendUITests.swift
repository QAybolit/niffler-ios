import XCTest

class SpendUITests: TestCase {
    
    func test_whenCreateNewAccount_shouldBeEmptySpendList() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let registrationPage = RegistrationPage(app: app)
        let spendsPage = SpendsPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.tapCreateNewAccountButton()
        registrationPage.inputNewUsername(username: "Robert-107")
        registrationPage.inputNewPassword(password: "12345")
        registrationPage.confirmNewPassword(password: "12345")
        registrationPage.tapSignUpButton()
        registrationPage.assertRegistrationIsSuccess()
        
        loginPage.tapLoginButton()
        spendsPage.assertSpendsListIsEmpty()
    }
    
    func test_whenAddSpend_shouldShowSpendInList() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let spendsPage = SpendsPage(app: app)
        let newSpendPage = NewSpendPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "stage", password: "12345")
        spendsPage.waitSpendsScreen()
        
        let title = UUID().uuidString
        
        spendsPage.addSpend()
        newSpendPage.waitNewSpendsScreen()
        newSpendPage.input(amount: "1000")
        newSpendPage.input(description: title)
        newSpendPage.waitSelectCategoryButton()
        newSpendPage.tapSelectCategoryButton()
        newSpendPage.selectCategory(name: "Покупки")
        newSpendPage.createSpend()
        spendsPage.waitSpendsScreen()
        
        spendsPage.assertNewSpendIsDisplayed(spendName: title)
    }
    
    func test_addFirstSpendForNewAccount() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let registrationPage = RegistrationPage(app: app)
        let spendsPage = SpendsPage(app: app)
        let newSpendPage = NewSpendPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.tapCreateNewAccountButton()
        registrationPage.inputNewUsername(username: "Robert-106")
        registrationPage.inputNewPassword(password: "12345")
        registrationPage.confirmNewPassword(password: "12345")
        registrationPage.tapSignUpButton()
        registrationPage.assertRegistrationIsSuccess()
        
        loginPage.tapLoginButton()
        spendsPage.assertSpendsListIsEmpty()
        
        let spend = UUID().uuidString
        let category = UUID().uuidString
        
        spendsPage.addSpend()
        newSpendPage.waitNewSpendsScreen()
        newSpendPage.input(amount: "1000")
        newSpendPage.input(description: spend)
        newSpendPage.waitSelectCategoryButton()
        newSpendPage.tapSelectCategoryButton()
        newSpendPage.addNewCategory(name: category)
        newSpendPage.createSpend()
        spendsPage.waitSpendsScreen()
        
        spendsPage.assertNewSpendIsDisplayed(spendName: spend)
        spendsPage.assertNewCategoryIsDisplayed(category: category)
    }
    
    func test_whenNoCategoriesFound_createNewCategory() throws {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let spendsPage = SpendsPage(app: app)
        let newSpendPage = NewSpendPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "Robert-109", password: "12345")
        spendsPage.waitSpendsScreen()
        
        let spend = UUID().uuidString
        let category = "Покупки"
        
        if spendsPage.spendsCount() == 0 || !spendsPage.categoryIsExist(name: category) {
            spendsPage.addSpend()
            newSpendPage.waitNewSpendsScreen()
            newSpendPage.input(amount: "1000")
            newSpendPage.input(description: spend)
            newSpendPage.waitSelectCategoryButton()
            newSpendPage.tapSelectCategoryButton()
            newSpendPage.tapNewCategoryButton()
            newSpendPage.addNewCategory(name: category)
            newSpendPage.createSpend()
        } else {
            spendsPage.addSpend()
            newSpendPage.waitNewSpendsScreen()
            newSpendPage.input(amount: "1000")
            newSpendPage.input(description: spend)
            newSpendPage.waitSelectCategoryButton()
            newSpendPage.tapSelectCategoryButton()
            newSpendPage.selectCategory(name: category)
            newSpendPage.createSpend()
        }
        spendsPage.waitSpendsScreen()
        spendsPage.assertNewSpendIsDisplayed(spendName: spend)
    }
}
