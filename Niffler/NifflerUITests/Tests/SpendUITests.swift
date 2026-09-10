import XCTest

class SpendUITests: BaseTestCase {
    
    func test_whenCreateNewAccount_shouldBeEmptySpendList() throws {
        
        launchAppWithoutLogin()
        loginPage
            .tapCreateNewAccountButton()
        
        registrationPage
            .input(username: "Robert-107", password: "12345")
            .tapSignUpButton()
            .assertRegistrationIsSuccess()
        
        loginPage
            .tapLoginButton()
        
        spendsPage
            .assertSpendsListIsEmpty()
    }
    
    func test_whenAddSpend_shouldShowSpendInList() throws {
        
        let title = UUID().uuidString
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "stage", password: "12345")
        
        spendsPage
            .waitSpendsScreen()
            .addSpend()
        
        newSpendPage
            .waitNewSpendsScreen()
            .input(amount: "1000", description: title)
            .waitSelectCategoryButton()
            .tapSelectCategoryButton()
            .selectCategory(name: "Покупки")
            .createSpend()
        
        spendsPage
            .waitSpendsScreen()
            .assertNewSpendIsDisplayed(spendName: title)
    }
    
    func test_addFirstSpendForNewAccount() throws {
        
        let spend = UUID().uuidString
        let category = UUID().uuidString
        
        launchAppWithoutLogin()
        loginPage
            .tapCreateNewAccountButton()
        
        registrationPage
            .input(username: "Robert-106", password: "12345")
            .tapSignUpButton()
            .assertRegistrationIsSuccess()
        
        loginPage
            .tapLoginButton()
        
        spendsPage
            .assertSpendsListIsEmpty()
            .addSpend()
        
        newSpendPage
            .waitNewSpendsScreen()
            .input(amount: "1000", description: spend)
            .waitSelectCategoryButton()
            .tapSelectCategoryButton()
            .addNewCategory(name: category)
            .createSpend()
        
        spendsPage
            .waitSpendsScreen()
            .assertNewSpendIsDisplayed(spendName: spend)
            .assertNewCategoryIsDisplayed(category: category)
    }
    
    func test_whenNoCategoriesFound_createNewCategory() throws {
        
        let spend = UUID().uuidString
        let category = "Покупки"
        
        launchAppWithoutLogin()
        loginPage
            .input(login: "Robert-109", password: "12345")
        
        spendsPage
            .waitSpendsScreen()
        
        if spendsPage.spendsCount() == 0 || !spendsPage.categoryIsExist(name: category) {
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
        } else {
            spendsPage
                .addSpend()
            newSpendPage
                .waitNewSpendsScreen()
                .input(amount: "1000", description: spend)
                .waitSelectCategoryButton()
                .tapSelectCategoryButton()
                .selectCategory(name: category)
                .createSpend()
        }
        spendsPage
            .waitSpendsScreen()
            .assertNewSpendIsDisplayed(spendName: spend)
    }
}
