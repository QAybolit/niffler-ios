import XCTest


class ProfilePage: BasePage {
    
    func delete(category: String) -> Self {
        XCTContext.runActivity(named: "Удаляю свайпом категорию \(category) из списка") { _ in
            app.collectionViews.cells.staticTexts[category].swipeLeft()
            app.buttons["Delete"].tap()
        }
        return self
    }
    
    func closeProfileScreen() {
        XCTContext.runActivity(named: "Закрываю экран профиля") { _ in
            app.buttons["Close"].tap()
        }
    }
    
    func waitProfileScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидаю экран профиля") { _ in
            let isFound = app.staticTexts["User info"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались экрана профиля",
                          file: file, line: line)
        }
        return self
    }
    
    func categoryIsNotExist(name: String) -> Bool {
        return app.collectionViews.cells.staticTexts[name].waitForNonExistence(timeout: 3)
    }
    
    func assertCategoryIsNotInList(category: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверяю, что переданная категория \(category) не отображается в списке категорий") { _ in
            
            let isNotFound = categoryIsNotExist(name: category)
            XCTAssertTrue(isNotFound,
                          "Нашли нужную категорию на экране",
                          file: file, line: line
            )
        }
        return self
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

