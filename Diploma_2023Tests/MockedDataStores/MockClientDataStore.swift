//
//  MockClientDataStore.swift
//  Diploma_2023Tests
//
//  Created by Martin Bernát on 28/06/2023.
//

import Foundation
import XCTest

// MARK: - ClientsDataStore - Mock

class MockClientsDataStore: ClientsDataStore {
    var mockAllClients: [Client] = [] // Mutable for testing
    var wasCreateClientCalled = false
    var wasUpdateClientCalled = false
    var wasDeleteClientCalled = false

    override func createClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasCreateClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    override func updateClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasUpdateClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    override func deleteClient(_ client: Client, completion: @escaping (Result<Void, Error>) -> Void) {
        wasDeleteClientCalled = true
        // For simplicity, let's assume it always succeeds.
        completion(.success(()))
    }

    // No need to override fetchClients or other methods, because those won't be called in tests.
}




// MARK: - ClientsDataStore - Tests

//@testable import Diploma_2023App

final class ClientsDataStoreTests: XCTestCase {
    
    var sut: ClientsDataStore!
    var mockClientRepository: MockClientRepository!
    var mockAuthService: AnyAuthenticationService!
    
    override func setUp() {
        super.setUp()
        
        mockClientRepository = MockClientRepository()
        let mockAuthServiceImpl = MockAuthenticationService()
        
        mockAuthService = AnyAuthenticationService(mockAuthServiceImpl)
        
        sut = ClientsDataStore(clientRepository: mockClientRepository, authenticationService: mockAuthService)
    }
    
    
    // FETCH CLIENT
    func testFetchClients_TriggeredByAuthService_WhenUserIdPresent_CallsFetchClientsOnRepository() {
        // Arrange
        let email = "test@email.com"  // Use mock email
        let password = "testPassword"  // Use mock password
        
        // Act
        print(" \n\n TEST 1 \n\n")
        // Log in the user
        mockAuthService.signIn(email: email, password: password) { _ in
            // Empty completion block, you can ignore the result since it's a mock
        }
        
        // Assert
        // check if ClientDataStore fetched logged user and triggered data fetching
        XCTAssertTrue(mockClientRepository.wasFetchClientsCalled)
    }
    
    
    // CREATE CLIENT userid == nil
    func testCreateClient_WhenUserIdIsNil_ReturnsError() {
        print(" \n \n \n TEST 2")
        // Arrange
        let client = MockClient.getClient()
        var resultError: Error?
        
        // Create an expectation for a background download task.
        let expectation = self.expectation(description: "Signing out and then creating client")
        
        // First operation: Signing Out
        mockAuthService.signOut { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    // Only call createClient once we're back on the main thread after the userId update.
                    self.sut.createClient(client) { result in
                        if case .failure(let error) = result {
                            resultError = error
                            print(error)
                        }
                        expectation.fulfill() // move this inside the createClient callback
                    }
                }
            case .failure(let error):
                print("Error in signOut: \(error)")
                expectation.fulfill()
            }
        }

        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        waitForExpectations(timeout: 10, handler: nil)

        // Assert
        XCTAssertNotNil(resultError)
    }

//
//    // CREATE CLIENT userid == id
//    func testCreateClient_WithValidUserId_Succeeds() {
//        // Arrange
//        let newClient = Client(/*...*/)
//        let expectation = XCTestExpectation(description: "Create client")
//
//        mockAuthService.simulateLogin() // Simulate that a user is logged in
//
//        // Act
//        clientsDataStore.createClient(newClient) { result in
//            switch result {
//            case .success:
//                // Assert
//                XCTAssertTrue(self.mockClientRepository.createdClients.contains { $0.id == newClient.id })
//                expectation.fulfill()
//            case .failure:
//                XCTFail("Expected call to succeed but it failed.")
//            }
//        }
//
//        // Wait
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    // CREATE CLIENT userid == nil
//    func testCreateClient_WithNoUserId_Fails() {
//        // Arrange
//        let newClient = Client(/*...*/)
//
//        mockAuthService.simulateLogout() // Simulate that a user is logged out
//
//        // Act
//        clientsDataStore.createClient(newClient) { result in
//            switch result {
//            case .success:
//                XCTFail("Expected call to fail but it succeeded.")
//            case .failure(let error):
//                // Assert
//                XCTAssertEqual(error.localizedDescription, "User ID is not available")
//            }
//        }
//    }
//
//
//
//    func testUpdateClient_WithValidUserId_Succeeds() {
//        // Arrange
//        let updatedClient = Client(/*...*/)
//        let expectation = XCTestExpectation(description: "Update client")
//
//        mockAuthService.simulateLogin()
//
//        // Act
//        clientsDataStore.updateClient(updatedClient) { result in
//            switch result {
//            case .success:
//                // Assert
//                XCTAssertTrue(self.mockClientRepository.updatedClients.contains { $0.id == updatedClient.id })
//                expectation.fulfill()
//            case .failure:
//                XCTFail("Expected call to succeed but it failed.")
//            }
//        }
//
//        // Wait
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testUpdateClient_WithNoUserId_Fails() {
//        // Arrange
//        let updatedClient = Client(/*...*/)
//
//        mockAuthService.simulateLogout()
//
//        // Act
//        clientsDataStore.updateClient(updatedClient) { result in
//            switch result {
//            case .success:
//                XCTFail("Expected call to fail but it succeeded.")
//            case .failure(let error):
//                // Assert
//                XCTAssertEqual(error.localizedDescription, "User ID is not available")
//            }
//        }
//    }
//
//
//    func testDeleteClient_WithValidUserId_Succeeds() {
//        // Arrange
//        let clientToDelete = Client(/*...*/)
//        let expectation = XCTestExpectation(description: "Delete client")
//
//        mockAuthService.simulateLogin()
//
//        // Act
//        clientsDataStore.deleteClient(clientToDelete) { result in
//            switch result {
//            case .success:
//                // Assert
//                XCTAssertTrue(self.mockClientRepository.deletedClients.contains { $0.id == clientToDelete.id })
//                expectation.fulfill()
//            case .failure:
//                XCTFail("Expected call to succeed but it failed.")
//            }
//        }
//
//        // Wait
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testDeleteClient_WithNoUserId_Fails() {
//        // Arrange
//        let clientToDelete = Client(/*...*/)
//
//        mockAuthService.simulateLogout()
//
//        // Act
//        clientsDataStore.deleteClient(clientToDelete) { result in
//            switch result {
//            case .success:
//                XCTFail("Expected call to fail but it succeeded.")
//            case .failure(let error):
//                // Assert
//                XCTAssertEqual(error.localizedDescription, "User ID is not available")
//            }
//        }
//    }
//
//
//    func testClearClientImageUrl_WithValidUserId_Succeeds() {
//        // Arrange
//        let clientIdToClear = "someId"
//        let expectation = XCTestExpectation(description: "Clear client image URL")
//
//        mockAuthService.simulateLogin()
//
//        // Act
//        clientsDataStore.clearClientImageUrl(clientId: clientIdToClear) { result in
//            switch result {
//            case .success:
//                // Assert
//                XCTAssertTrue(self.mockClientRepository.clearedImageUrls.contains(clientIdToClear))
//                expectation.fulfill()
//            case .failure:
//                XCTFail("Expected call to succeed but it failed.")
//            }
//        }
//
//        // Wait
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func testClearClientImageUrl_WithNoUserId_Fails() {
//        // Arrange
//        let clientIdToClear = "someId"
//
//        mockAuthService.simulateLogout()
//
//        // Act
//        clientsDataStore.clearClientImageUrl(clientId: clientIdToClear) { result in
//            switch result {
//            case .success:
//                XCTFail("Expected call to fail but it succeeded.")
//            case .failure(let error):
//                // Assert
//                XCTAssertEqual(error.localizedDescription, "User ID is not available")
//            }
//        }
//    }


}
