//
//  ContentView.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 12/5/21.
//

import SwiftUI

struct ListView: View {
    // Network manager to fetch data
    private let networkManager = NetworkManager()
    
    @State private var presentingModal: Bool = false
    
    // Users to show in the list
    @State var users: [User] = []
    
    var body: some View {
        VStack {
            // MARK: List of users
            NavigationView {
                List(self.users) { user in
                    NavigationLink(destination: UserDetailsView(user)) {
                        UserRow(user: user)
                    }
                }.onAppear(perform: {
                    loadUsers()
                })
                .navigationTitle("Users")
                .navigationBarItems(trailing:
                        buildTopBar()
                )
            }
        }
    }
    
    // MARK: Other functions: Networking
    
    /// This function uses the network manager to request every user to the API.
    func loadUsers() {
        networkManager.fetchUsers(completion: { users in
            if let unwrappedUsers = users {
                self.users = unwrappedUsers
            }
        })
    }
    
    
    // MARK: Other functions: Views
    /// This function builds the top bar an returns it.
    /// - Returns: A HStack that has some buttons in it.
    private func buildTopBar() -> some View {
        HStack {
            
            // Refreshes the list
            Button(action: {
                self.presentingModal = true
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $presentingModal, content: {
                UserFormView($presentingModal, self)
            })
            
            // Refreshes the list
            Button(action: {
                loadUsers()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.title)
                    .foregroundColor(.black)
            }
            
            // Menu to order the list
            Menu {
                Button("Order by name") {
                    orderUsersBy(&users, by: "name")
                }
                Button("Order by birthdate (ascending)") {
                    orderUsersBy(&users, by: "date_ascending")
                }
                Button("Order by birthdate (descending)") {
                    orderUsersBy(&users, by: "date_descending")
                }
            } label: {
                Label("", systemImage: "line.horizontal.3.decrease.circle")
                    .foregroundColor(.black)
                    .font(.title)
            }
        }
    }
    
    // MARK: Other functions: Utils
    private func orderUsersBy(_ users: inout [User], by: String?) {
        if let by = by {
            switch by {
            case "name":
                users.sort(by: {
                    $0.name! < $1.name!
                })
                break
                
            case "date_ascending":
                users.sort(by: {
                    $0.birthdate! < $1.birthdate!
                })
                break
            
            case "date_descending":
                users.sort(by: {
                    $0.birthdate! > $1.birthdate!
                })
                break
                
            default:
                break
            }
        }
    }
}
