import XCTest

final class ProfileUITests: BaseTestCase {
    
    func test_whenAddNewSpendWithNewCategory_mustBeUpdatedProfileCategoryList() {
        
        let spend = UUID().uuidString
        let category = UUID().uuidString
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "stage", password: "12345")
        spendsPage
            .waitSpendsScreen()
            .tapMenuIcon()
            .waitMenu()
            .tapProfileButton()
        
        profilePage
            .waitProfileScreen()
            .assertCategoryIsNotInList(category: category)
            .closeProfileScreen()
        
        spendsPage
            .addSpend()
        
        newSpendPage
            .waitNewSpendsScreen()
            .input(amount: "1000", description: spend)
            .waitSelectCategoryButton()
            .tapSelectCategoryButton()
            .tapNewCategoryButton()
            .addNewCategory(name: category)
            .createSpend()
        
        spendsPage
            .waitSpendsScreen()
            .tapProfileButton()
        
        profilePage
            .waitProfileScreen()
            .assertCategoryIsInList(category: category)
        
    }
    
    func test_whenDeleteCategory_mustBeNoThisCategoryByNewSpendCreation() {
        
        let category = "503789DD-DA0E-416B-B5A1-BDA2128DEAE8"
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "stage", password: "12345")
        
        spendsPage
            .waitSpendsScreen()
            .tapMenuIcon()
            .waitMenu()
            .tapProfileButton()
        
        profilePage
            .waitProfileScreen()
            .delete(category: category)
            .closeProfileScreen()
                
        spendsPage
            .addSpend()
        
        newSpendPage
            .waitNewSpendsScreen()
            .waitSelectCategoryButton()
            .tapSelectCategoryButton()
            .assertCategoryIsNotInList(category: category)
    }
}
