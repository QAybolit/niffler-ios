import XCTest

class SpendsPage: BasePage {
    
    func tapMenuIcon() -> Self {
        XCTContext.runActivity(named: "Нажимаю на иконку меню") { _ in
            app.images["ic_menu"].tap()
        }
        return self
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
    
    @discardableResult
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            let isFound = app.scrollViews.switches.firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isFound,
                          "Не дождались экрана со списком трат",
                          file: file, line: line)
        }
        return self
    }
    
    func waitMenu(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду отображения меню") { _ in
            let isFound = app.staticTexts["Menu"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались отображения меню",
                          file: file, line: line)
        }
        return self
    }
    
    func assertIsSpendsViewAppeared() {
        XCTContext.runActivity(named: "Проверяю, что количество трат на экране больше 0") { _ in
            waitSpendsScreen()
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1)
        }
    }
    
    @discardableResult
    func assertNewSpendIsDisplayed(spendName: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверяю, что новая трата \(spendName) отображается на странице трат") { _ in
            
            let isFound = app.scrollViews.staticTexts[spendName].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не нашли нужную трату на экране",
                          file: file, line: line
            )
        }
        return self
    }
    
    func spendsCount() -> Int {
        return app.scrollViews.staticTexts.count
    }
    
    @discardableResult
    func assertSpendsListIsEmpty(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверяю, что на странице трат не отображается ни одной траты") { _ in
            XCTAssertEqual(spendsCount(), 0,
                           "Список трат не пустой",
                           file: file, line: line)
        }
        return self
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

