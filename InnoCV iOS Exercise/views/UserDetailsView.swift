//
//  UserDetailsView.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 14/5/21.
//

import SwiftUI

struct UserDetailsView: View {
    
    // User to display
    private var user: User
    
    // Used to pop the view when the operation finishes
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Used to update the view when the user changes
    @State private var userName: String
    @State private var userBirthdate: String
    
    // Used to show and hide alerts
    @State private var presentingAlert: Bool = false
    @State private var presentingModal = false
    
    init(_ user: User) {
        self.user = user
        
        self._userName = State(wrappedValue: user.name ?? "Unknown name")
        self._userBirthdate = State(wrappedValue: user.birthdate?.components(separatedBy: "T")[0] ?? "Unknown birthdate")
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("User name")
                    Spacer()
                    Text($userName.wrappedValue)
                        .fontWeight(Font.Weight.semibold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }
                
                Divider()
                
                HStack {
                    Text("User birthdate")
                    Spacer()
                    Text($userBirthdate.wrappedValue)
                        .fontWeight(Font.Weight.semibold)
                        .font(.title)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    // Edit button
                    Button(action: {
                        self.presentingModal = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.largeTitle)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .background(Color.init("Teal"))
                    .cornerRadius(50.0)
                    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 16, trailing: 8))
                    .sheet(isPresented: $presentingModal, content: {
                        UserFormView(user, $presentingModal, self)
                    })
                    
                    // Delete button
                    Button(action: {
                        self.presentingAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(50.0)
                    .padding(EdgeInsets.init(top: 0, leading: 8, bottom: 16, trailing: 16))
                    .alert(isPresented: $presentingAlert, content: {
                        Alert(
                            title: Text("Delete \(user.name!)"),
                            message: Text("You are about to delete this user. Are you sure you want to do this!"),
                            primaryButton: .cancel({ self.presentingAlert = false }),
                            secondaryButton: .default(
                                Text("OK"),
                                action: {
                                    NetworkManager().deleteUser(user: user, completion: { _ in self.presentationMode.wrappedValue.dismiss() })
                                }))
                    })
                    
                }
            }
            .padding()
        }
    }
    
    /// Updates the UI given an user.
    /// - Parameter withUser: User to show
    mutating func updateUI(withUser user: User) {
        self.userName = user.name!
        self.userBirthdate = user.birthdate?.components(separatedBy: "T")[0] ?? "Unknown birthdate"
    }
    
}
