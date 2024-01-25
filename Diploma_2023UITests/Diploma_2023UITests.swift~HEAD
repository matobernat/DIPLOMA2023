//
//  Diploma_2023UITests.swift
//  Diploma_2023UITests
//
//  Created by Martin Bernát on 13/12/2023.
//

import XCTest

final class Diploma_2023UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    
    // APP LOEADS ON LANDING PAGE
    func testAppLaunchesWithTodayView() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        // Check if TodayView is present
        let todayViewExists = app.otherElements["TodayViewLabel"].waitForExistence(timeout: 3)

        XCTAssertTrue(todayViewExists, "TodayView did not appear.")
        
    }
    
    
    // EXISTANCE OF CLIENTS DATA
    func testExistanceOfClientsData() throws {
        let app = XCUIApplication()
        app.launch()

        // Tap on the Clients tab
        app.buttons["TabItemClient"].tap()
       
        
        
        // Wait for the LazyVgrid to appear
        let gridExists = app.otherElements["LazyVGrid"].waitForExistence(timeout: 3)
        XCTAssertTrue(gridExists, "LazyVGrid did not appear.")
        
        
        
        // Wait for the FemaleAvatar to appear
        let avatarExists = app.images["clientAvatarFemale"].waitForExistence(timeout: 3)
        XCTAssertTrue(avatarExists, "ClientAvatar did not appear.")
    }

    
    
    // EXISTANCE OF DATA WITHIN CLIENT
    func testExistanceOfClientData() throws {
        let app = XCUIApplication()
        app.launch()

        // Tap on the Clients tab
        app.buttons["TabItemClient"].tap()

        
        
        print("DEBUG DESCRIPTION: \n\n")
        print(app.debugDescription)
        print("\n\n DEBUG DESCRIPTION END  \n\n")
        
                
        
        
        // Wait for the LazyVgrid to appear
        let gridExists = app.otherElements["LazyVGrid"].waitForExistence(timeout: 3)
        XCTAssertTrue(gridExists, "LazyVGrid did not appear.")
        
        
        
        // Wait for the FemaleAvatar to appear
        let avatarExists = app.images["clientAvatarFemale"].waitForExistence(timeout: 3)
        XCTAssertTrue(avatarExists, "ClientAvatar did not appear.")
        
        
        
        app.images["clientAvatarFemale"].tap()
        
        
        
        print("DEBUG DESCRIPTION: \n\n")
        print(app.debugDescription)
        print("\n\n DEBUG DESCRIPTION END  \n\n")
        
                
        XCTAssertTrue(true)
        
        
    }
    
    
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
