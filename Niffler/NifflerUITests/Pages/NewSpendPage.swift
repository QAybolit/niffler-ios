import XCTest

class NewSpendPage: BasePage {
    
    func input(amount: String, description: String) -> Self {
        XCTContext.runActivity(named: "Ввожу размер траты \(amount) и описание \(description)") { _ in
            input(amount: amount)
            input(description: description)
        }
        return self
    }
    
    func input(amount: String) {
        XCTContext.runActivity(named: "Ввожу размер траты \(amount)") { _ in
            app.textFields["amountField"].typeText(amount)
        }
    }
    
    func input(description: String) {
        XCTContext.runActivity(named: "Ввожу описание траты \(description)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(description)
        }
    }
    
    @discardableResult
    func tapSelectCategoryButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю на кнопку выбора категории") { _ in
            app.buttons["Select category"].tap()
        }
        return self
    }
    
    func selectCategory(name: String) -> Self {
        XCTContext.runActivity(named: "Выбираю категорию \(name)") { _ in
            app.buttons[name].tap()
        }
        return self
    }
    
    func createSpend() {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания траты") { _ in
            app.buttons["Add"].tap()
        }
    }
    
    func waitNewSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидаю экран создания новой траты") { _ in
            let isFound = app.staticTexts["New Spend"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались экрана создания новой траты",
                          file: file, line: line)
        }
        return self
    }
    
    func waitSelectCategoryButton(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидаю кнопку выбора категории") { _ in
            let isFound = app.buttons["Select category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки выбора категории",
                          file: file, line: line)
        }
        return self
    }
    
    func tapNewCategoryButton() -> Self {
        XCTContext.runActivity(named: "Нажимаю на кнопку создания новой категории") { _ in
            app.buttons["+ New category"].tap()
        }
        return self
    }
    
    func waitNewCategoryButton(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю кнопку создания новой категории") { _ in
            let isFound = app.buttons["+ New category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались кнопки создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    func waitAddCategoryWindow(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Ожидаю окно создания новой категории") { _ in
            let isFound = app.staticTexts["Add category"].waitForExistence(timeout: 5)
            XCTAssertTrue(isFound,
                          "Не дождались окна создания новой категории",
                          file: file, line: line
            )
        }
    }
    
    func addNewCategory(name: String) -> Self {
        XCTContext.runActivity(named: "Создаю новую категорию") { _ in
            waitAddCategoryWindow()
            app.textFields["Name"].typeText(name)
            app.buttons["Add"].firstMatch.tap()
        }
        return self
    }
    
    func categoryIsNotExist(name: String) -> Bool {
        return app.collectionViews.cells.buttons[name].waitForNonExistence(timeout: 3)
    }
    
    func assertCategoryIsNotInList(category: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю, что переданная категория \(category) не отображается в списке категорий") { _ in
            
            let isNotFound = categoryIsNotExist(name: category)
            XCTAssertTrue(isNotFound,
                          "Нашли переданную категорию на экране",
                          file: file, line: line
            )
        }
    }
}
