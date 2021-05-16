//
//  UserRow.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 12/5/21.
//

import SwiftUI


struct UserRow: View {
    var user: User

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formatName(name: user.name))
                Text(formatDate(date: user.birthdate))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
    }
    
    func formatName(name: String?) -> String {
        let errorMessage = "Unknown name"
        
        guard let name = name, !name.isEmpty else {
            return errorMessage
        }
        
        return name
    }
    
    func formatDate(date: String?) -> String {
        let errorMessage = "Unknown birthdate"
        
        guard let date = date, !date.isEmpty else {
            return errorMessage
        }
        
        return date.components(separatedBy: "T")[0]
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserRow(user: User(id: 0, name: "User0", birthdate: ""))
            UserRow(user: User(id: 1, name: "User1", birthdate: ""))
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
