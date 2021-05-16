//
//  Api.swift
//  InnoCV iOS Exercise
//
//  Created by Pablo Figueroa Martínez on 12/5/21.
//

import Foundation
import Combine

class NetworkManager: NSObject, URLSessionDelegate {
    
    private let baseURL = "http://hello-world.innocv.com/api/"
    
    /// Function that requests to the API to create an user.
    /// - Parameter user: The user to create.
    /// - Parameter completion: Function to execute after the operation is completed.
    func createUser(user: User, completion: @escaping ((User)?) -> Void) {
        var request = URLRequest(url: URL(string: baseURL + "User")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            // Check if there was any error
            guard error == nil else {
                print("There was an error while retrieving the data...")
                return
            }
            // Decode the JSON into the array of users
            completion(user)
        }
        
        task.resume()
    }
    
    /// Function that requests to the API to delete an user.
    /// - Parameter user: The user to delete.
    /// - Parameter completion: Function to execute after the operation is completed.
    func deleteUser(user: User, completion: @escaping ((User)?) -> Void) {
        var request = URLRequest(url: URL(string: baseURL + "User/\(user.id!)")!)
        request.httpMethod = "DELETE"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            // Check if there was any error
            guard error == nil else {
                print("There was an error while retrieving the data...")
                return
            }
            // Decode the JSON into the array of users
            completion(user)
        }
        
        task.resume()
    }
    
    /// Function that requests to the API to update an user.
    /// - Parameter user: The user to update.
    /// - Parameter completion: Function to execute after the operation is completed.
    func updateUser(user: User, completion: @escaping ((User)?) -> Void) {
        var request = URLRequest(url: URL(string: baseURL + "User")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            // Check if there was any error
            guard error == nil else {
                print("There was an error while retrieving the data...")
                return
            }
            // Decode the JSON into the array of users
            completion(user)
        }
        
        task.resume()
    }
    
    /// Function that requests to the API to retrieve the list of users.
    /// - Parameter completion: Function to execute after the operation is completed.
    func fetchUsers(completion: @escaping ([User]?) -> Void) {
        
        let request = URLRequest(url: URL(string: baseURL + "User")!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
            // Check if there was any error
            guard error == nil else {
                print("There was an error while retrieving the data...")
                return
            }
            
            // Check if there's data
            guard let data = data else {
                print("Invalid response...")
                return
            }
            
            // Decode the JSON into the array of users
            do {
                var users = try JSONDecoder().decode([User].self, from: data)
                
                users.removeAll(where: { user in
                    user.name == nil
                })
                
                users.sort(by: {
                    if let name0 = $0.name, let name1 = $1.name {
                        return name0 < name1
                    } else {
                        return true
                    }
                })
                completion(users)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
