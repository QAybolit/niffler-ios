import XCTest

final class ProfileUITests: TestCase {
    
    func test_whenAddNewSpendWithNewCategory_mustBeUpdatedProfileCategoryList() {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let spendsPage = SpendsPage(app: app)
        let profilePage = ProfilePage(app: app)
        let newSpendPage = NewSpendPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "stage", password: "12345")
        spendsPage.waitSpendsScreen()
        
        let spend = UUID().uuidString
        let category = UUID().uuidString
        
        spendsPage.tapMenuIcon()
        spendsPage.waitMenu()
        spendsPage.tapProfileButton()
        profilePage.waitProfileScreen()
        profilePage.assertCategoryIsNotInList(category: category)
        profilePage.closeProfileScreen()
                
        spendsPage.addSpend()
        newSpendPage.waitNewSpendsScreen()
        newSpendPage.input(amount: "1000")
        newSpendPage.input(description: spend)
        newSpendPage.waitSelectCategoryButton()
        newSpendPage.tapSelectCategoryButton()
        newSpendPage.tapNewCategoryButton()
        newSpendPage.addNewCategory(name: category)
        newSpendPage.createSpend()
        
        spendsPage.waitSpendsScreen()
        spendsPage.tapProfileButton()
        profilePage.waitProfileScreen()
        
        profilePage.assertCategoryIsInList(category: category)
        
    }
    
    func test_whenDeleteCategory_mustBeNoThisCategoryByNewSpendCreation() {
        let app = XCUIApplication()
        
        let loginPage = LoginPage(app: app)
        let spendsPage = SpendsPage(app: app)
        let profilePage = ProfilePage(app: app)
        let newSpendPage = NewSpendPage(app: app)
        
        loginPage.launchAppWithoutLogin()
        loginPage.input(login: "stage", password: "12345")
        spendsPage.waitSpendsScreen()
        
        let category = "503789DD-DA0E-416B-B5A1-BDA2128DEAE8"
        
        spendsPage.tapMenuIcon()
        spendsPage.waitMenu()
        spendsPage.tapProfileButton()
        profilePage.waitProfileScreen()
        profilePage.delete(category: category)
        profilePage.closeProfileScreen()
                
        spendsPage.addSpend()
        newSpendPage.waitNewSpendsScreen()
        newSpendPage.waitSelectCategoryButton()
        newSpendPage.tapSelectCategoryButton()
        
        newSpendPage.assertCategoryIsNotInList(category: category)
    }
}
