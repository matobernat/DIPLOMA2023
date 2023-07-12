//
//  ClientsViewModelTests.swift
//  Diploma_2023Tests
//
//  Created by Martin Bernát on 28/06/2023.
//

import XCTest
@testable import Diploma_2023

final class ClientsViewModelTests: XCTestCase {
    
    var sut: ClientsViewModel!
    var mockClientsDataStore: MockClientsDataStore!
    var mockCategoryDataStore: MockCategoryDataStore!
    var mockAccountDataStore: MockAccountDataStore!

    override func setUpWithError() throws {
        super.setUp()
        mockClientsDataStore = MockClientsDataStore()
        mockCategoryDataStore = MockCategoryDataStore()
        mockAccountDataStore = MockAccountDataStore()

        sut = ClientsViewModel(clientsDataStore: mockClientsDataStore, categoryDataStore: mockCategoryDataStore, accountDataStore: mockAccountDataStore)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockClientsDataStore = nil
        mockCategoryDataStore = nil
        mockAccountDataStore = nil
        super.tearDown()
    }

    func testCreateClient() throws {
        // Arrange
        let newClient = Client(/*...*/)

        // Act
        sut.createClient(client: newClient)

        // Assert
        XCTAssertEqual(mockClientsDataStore.createdClients, [newClient], "Client was not created as expected")
    }

    //... other tests for other methods

    func testPerformanceExample() throws {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
