//
//  ResourceRequest.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import Foundation

enum GetResourcesRequest<ResourceType> {
    // 1
    case success([ResourceType])
    // 2
    case failure
}

/*
 This enum represents a generic resource type and provides two cases:
 1.A success case that stores an array of the resource type.
 2.A failure case.
 */

enum SaveResult<ResourceType> {
    case success(ResourceType)
    case failure
}

// 1
struct ResourceRequest<ResourceType>
where ResourceType: Codable {
    
    // 2
    let baseURL = "http://localhost:8080/api/"
    let resourceURL: URL
    
    // 3
    init(resourcePath: String) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError()
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }
    
    // 4
    func getAll(
        completion: @escaping
        (GetResourcesRequest<ResourceType>) -> Void) {
        // 5
        let dataTask = URLSession.shared
            .dataTask(with: resourceURL) {
                data, res, error in
                // 6
                guard let jsonData = data else {
                    completion(.failure)
                    return
                }
                do {
                    // 7
                    let resources
                        = try JSONDecoder().decode([ResourceType].self,
                                                   from: jsonData)
                    // 8
                    completion(.success(resources))
                } catch {
                    // 9
                    completion(.failure)
                }
        }
        // 10
        dataTask.resume()
    }
    
    /*
     Here’s what this does:
     1.Define a generic ResourceRequest type whose generic parameter must conform to Codable.
     2.Set the base URL for the API. Update this with the URL of your Vapor Cloud API, for example https://rw-til.vapor.cloud/api/.
     3.Initialize the URL for the particular resource.
     4.Define a function to get all values of the resource type from the API. This takes a completion closure as a parameter.
     5.Create a data task with the resource URL.
     6.Ensure the response returns some data. Otherwise, call the completion(_:) closure with the .failure case.
     7.Decode the response data into an array of ResourceTypes.
     8.Call the completion(_:) closure with the .success case and return the array of ResourceTypes.
     9.Catch any errors and return failure.
     10.Start the dataTask.
     */
    
    
    // 1
    func save(_ resourceToSave: ResourceType,
              completion:
        @escaping (SaveResult<ResourceType>) -> Void) {
        do {
            // 2
            var urlRequest = URLRequest(url: resourceURL)
            // 3
            urlRequest.httpMethod = "POST"
            // 4
            urlRequest.addValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            // 5
            urlRequest.httpBody = try JSONEncoder().encode(resourceToSave)
            // 6
            let dataTask = URLSession.shared
                .dataTask(with: urlRequest) {
                    data, response, _ in
                    // 7
                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200,
                        let jsonData = data else {
                            completion(.failure)
                            return
                    }
                    do {
                        // 8
                        let resource =
                            try JSONDecoder().decode(ResourceType.self,
                                                     from: jsonData)
                        completion(.success(resource))
                    } catch {
                        // 9
                        completion(.failure)
                    }
            }
            // 10
            dataTask.resume()
            // 11
        } catch {
            completion(.failure)
        }
    }
    /*
     Here’s what this does:
     1.Ensure the name text field contains a non-empty string.
     2.Ensure the username text field contains a non-empty string.
     3.Create a new user from the provided data.
     4.Create a ResourceRequest for a user and call save(_:completion:).
     5.If the save fails, display an error message.
     6.If the save succeeds, return to the previous view: the users table.
     */
}
