//
//  EditView.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 14/5/21.
//

import SwiftUI

struct UserFormView: View {
    
    // User to update/create
    private var user: User?
    
    // Parent view
    @State private var userDetailsView: UserDetailsView?
    @State private var listView: ListView?
    
    // Used to present different views: alerts, progress indicator, etc.
    @Binding private var presentedAsModal: Bool
    @State private var presentingAlert: Bool = false
    @State private var presentingProgress: Bool = false
    
    // Form fields
    @State private var userName: String = ""
    @State private var userBirthdate: Date = Date()
    
    // Used to check if the form was properly filled.
    @State private var isNameEmpty = true
    @State private var isBirthdateEmpty = true
    
    init(_ user: User, _ presentedAsModal: Binding<Bool>, _ parent: UserDetailsView) {
        self.user = user
        self._presentedAsModal = presentedAsModal
        
        self._userDetailsView = State(wrappedValue: parent)
        
        self._userName = State(wrappedValue: user.name ?? "")
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let date = df.date(from: user.birthdate?.components(separatedBy: "T")[0] ?? "01-01-2000")
        self._userBirthdate = State(wrappedValue: date ?? Date())
    }
    
    init(_ presentedAsModal: Binding<Bool>, _ parent: ListView) {
        self._presentedAsModal = presentedAsModal
        self._listView = State(wrappedValue: parent)
    }
    
    var body: some View {
        ZStack {
            if presentingProgress {
                ProgressView()
            }
            Form {
                Section(header: Text("Edit user").font(.title3).foregroundColor(.gray)) {
                    // Text field
                    TextField("User name", text: $userName, onEditingChanged: { editing in
                        isNameEmpty = false
                    })
                    // Date picker
                    DatePicker("User birthdate", selection: $userBirthdate, in: ...Date().addingTimeInterval(-86400), displayedComponents: .date)
                    HStack {
                        Spacer()
                        // Submit button
                        Button(action: {
                            self.presentingProgress = true
                            if checkForm() {
                                self.presentingAlert = true
                            } else {
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd"
                                
                                let networkManager = NetworkManager()
                                if self.userDetailsView != nil {
                                    networkManager.updateUser(
                                        user: User(id: self.user!.id,
                                                   name: userName,
                                                   birthdate: df.string(from: userBirthdate)),
                                        completion: { user in
                                            userDetailsView!.updateUI(
                                                withUser: User(id: self.user!.id,
                                                               name: userName,
                                                               birthdate: df.string(from: userBirthdate))
                                            )
                                            self.presentedAsModal = false
                                    })
                                } else {
                                    networkManager.createUser(
                                        user: User(id: 0,
                                                   name: userName,
                                                   birthdate: df.string(from: userBirthdate)),
                                        completion: { _ in
                                            listView!.loadUsers()
                                            self.presentedAsModal = false
                                        })
                                }
                            }
                        }) {
                            HStack{
                                Image(systemName: "checkmark")
                                Text("Done")
                            }
                            .foregroundColor(.green)
                            .font(.title3)
                        }
                        .alert(isPresented: $presentingAlert, content: {
                            Alert(
                                title: Text("Oops! Something went wrong..."),
                                message: Text("Check the data you provided and try again."),
                                dismissButton: .default(Text("OK"), action: {
                                    self.presentingAlert = false
                                })
                            )
                        })
                    }
                }
            }
        }
    }
    
    private func checkForm() -> Bool {
        userName.isEmpty || userBirthdate > Date()
    }
}
