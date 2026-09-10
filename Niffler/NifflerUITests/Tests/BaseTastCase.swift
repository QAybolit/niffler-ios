import XCTest

class BaseTestCase: XCTestCase {
    
    var app: XCUIApplication!
    
    lazy var loginPage: LoginPage! = LoginPage(app: app)
    lazy var registrationPage: RegistrationPage! = RegistrationPage(app: app)
    lazy var spendsPage: SpendsPage! = SpendsPage(app: app)
    lazy var newSpendPage: NewSpendPage! = NewSpendPage(app: app)
    lazy var profilePage: ProfilePage! = ProfilePage(app: app)
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        
        loginPage = nil
        registrationPage = nil
        spendsPage = nil
        newSpendPage = nil
        profilePage = nil
        
        super.tearDown()
    }
    
    func launchAppWithoutLogin() {
        XCTContext.runActivity(named: "Запускаю приложение в режиме 'Без авторизации'") { _ in
            app.launchArguments = ["RemoveAuthOnStart"]
            app.launch()
        }
    }
    
}
