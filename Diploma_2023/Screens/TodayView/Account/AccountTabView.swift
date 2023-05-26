//
//  AccountTabView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 26/05/2023.
//

import SwiftUI
import Combine

class AccountViewTabModel: ObservableObject {
    @Published var loggedAccount: Account?

    private let accountDataStore: AccountDataStore
    private let authenticationService: AuthenticationService
    private var cancellable: AnyCancellable?

    init() {
        self.accountDataStore = AppDependencyContainer.shared.accountDataStore
        self.authenticationService = AppDependencyContainer.shared.authenticationService
        
        loggedAccount = self.accountDataStore.loggedAccount

        // subscription
        cancellable = self.accountDataStore.$loggedAccount.sink { [weak self] loggedAccount in
            self?.loggedAccount = loggedAccount
        }
    }
    
    func signOut() {
        authenticationService.signOut { success in
            // Handle success or failure (e.g., show an alert)
        }
    }
}


struct AccountTabView: View {

    @StateObject private var vm = AccountViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("Account")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding()

            VStack(alignment: .leading, spacing: 16) {
                Text("Account Email")
                    .font(.system(size: 18, weight: .bold))

                Text(vm.loggedAccount?.email ?? "Not Logged Account")
                    .font(.system(size: 16))

                Text("Current Profile")
                    .font(.system(size: 18, weight: .bold))

                Text(vm.loggedAccount?.loggedProfile?.name ?? "Not Logged Profile")
                    .font(.system(size: 16))


                Button(action: {
                    vm.signOut()
                }, label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
    }
}
