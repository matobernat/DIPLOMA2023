//
//  DataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 15/04/2023.
//

import Combine
import SwiftUI

//class DataStore: ObservableObject {
//    @Published var loggedAccount: Account?
//    @Published var loggedProfile: Profile?
//    @Published var allProfiles: [Profile] = []
//
//
//    private let authentication: Authentication
//    private let repositories: Repositories
//
//
//    init(authentication: Authentication, repositories: Repositories) {
//        self.authentication = authentication
//        self.repositories = repositories
//
//        authentication.userIdChanged = { [weak self] userId in
//            if let userId = userId {
//                self?.repositories.fetchAccount(userId: userId) { account in
//                    self?.loggedAccount = account
//
//                    self?.repositories.fetchAllProfiles(for: userId) { profiles in
//                        DispatchQueue.main.async {
//                            self?.allProfiles = profiles ?? []
//
//                            // Set the first profile as the loggedProfile if it's not set yet
//                            if self?.loggedProfile == nil, let firstProfile = profiles?.first {
//                                self?.loggedProfile = firstProfile
//                            }
//                        }
//                    }
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self?.loggedAccount = nil
//                    self?.loggedProfile = nil
//                    self?.allProfiles = []
//                }
//            }
//        }
//    }
//
//    func signIn(email: String, password: String) {
//        authentication.signIn(email: email, password: password) { result in
//            // Handle errors if necessary
//        }
//    }
//
//    func signOut() {
//        authentication.signOut()
//    }
//
//    func register(email: String, password: String, profileName: String) {
//        authentication.register(email: email, password: password) { [weak self] result in
//            switch result {
//            case .success(let userId):
//                let account = Account(id: userId, name: nil, email: email, address: "", globalCategoriesIDs: [], trainerProfilesIDs: [])
//                let profile = Profile(id: UUID().uuidString, accountID: userId, name: profileName, email: email, profileCategoryIDs: [])
//
//                self?.repositories.createAccount(account: account) { success in
//                    if success {
//                        self?.repositories.createProfile(profile: profile) { success in
//                            if success {
//                                DispatchQueue.main.async {
//                                    self?.loggedAccount = account
//                                    self?.loggedProfile = profile
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("Error registering user: \(error.localizedDescription)")
//            }
//        }
//    }
//}


//protocol DataTypeStore: AnyObject {
//    associatedtype DataType
//    
//    func fetchData(userId: String, completion: @escaping ([DataType]?) -> Void)
//    func createItem(item: DataType, completion: @escaping (Bool) -> Void)
//    func resetData()
//}

//class DataStore: ObservableObject {
//    var accountStore: AccountStore
//    var profileStore: ProfileStore
//    // Add references to other data type store classes
//
//    private let authentication: Authentication
//
//    init(authentication: Authentication, repositories: Repositories) {
//        self.authentication = authentication
//        self.accountStore = AccountStore(repository: repositories.accountRepository)
//        self.profileStore = ProfileStore(repository: repositories.profileRepository)
//        // Initialize other data type store classes
//
//        authentication.userIdChanged = { [weak self] userId in
//            if let userId = userId {
//                self?.accountStore.fetchData(userId: userId) { accounts in
//                    if let account = accounts?.first {
//                        DispatchQueue.main.async {
//                            self?.accountStore.loggedAccount = account
//                        }
//                    }
//                }
//
//                self?.profileStore.fetchData(userId: userId) { profiles in
//                    DispatchQueue.main.async {
//                        self?.profileStore.allProfiles = profiles ?? []
//
//                        if self?.profileStore.loggedProfile == nil, let firstProfile = profiles?.first {
//                            self?.profileStore.loggedProfile = firstProfile
//                        }
//                    }
//                }
//
//            } else {
//                self?.resetData()
//            }
//        }
//    }
//
//    func resetData() {
//        accountStore.resetData()
//        profileStore.resetData()
//        // Call resetData() for other data type store classes
//    }
//
//    // ...
//}




//class AccountStore: DataTypeStore {
//    @Published var loggedAccount: Account?
//
//    private let repository: AccountRepository
//
//    init(repository: AccountRepository) {
//        self.repository = repository
//    }
//
//    func fetchData(userId: String, completion: @escaping ([Account]?) -> Void) {
//        repository.fetchAccount(userId: userId) { account in
//            completion([account].compactMap { $0 })
//        }
//    }
//
//    func createItem(item: Account, completion: @escaping (Bool) -> Void) {
//        repositories.createAccount(account: item) { success in
//            completion(success)
//        }
//    }
//
//    func resetData() {
//        loggedAccount = nil
//    }
//}
//
//
//class ProfileStore: DataTypeStore {
//    @Published var loggedProfile: Profile?
//    @Published var allProfiles: [Profile] = []
//
//    private let repository: ProfileRepository
//
//    init(repository: ProfileRepository) {
//        self.repository = repository
//    }
//
//    func fetchData(userId: String, completion: @escaping ([Profile]?) -> Void) {
//        repository.fetchAllProfiles(for: userId) { profiles in
//            completion(profiles)
//        }
//    }
//
//    func createItem(item: Profile, completion: @escaping (Bool) -> Void) {
//        repository.createProfile(profile: item) { success in
//            completion(success)
//        }
//    }
//
//    func resetData() {
//        loggedProfile = nil
//        allProfiles = []
//    }
//}
//
