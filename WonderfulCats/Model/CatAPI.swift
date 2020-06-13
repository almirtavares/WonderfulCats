//
//  CatAPI.swift
//  WonderfulCats
//
//  Created by Almir Tavares on 12/06/20.
//  Copyright © 2020 DevVenture. All rights reserved.
//

import Foundation


enum APIError: Error {
    case badURL
    case taskError
    case badResponse
    case invalidStatusCode(Int)
    case noData
    case invalidJSON
}

class CatAPI {
    
    private static let basePath = "https://api.imgur.com/3/gallery/search/?q=cats"
    private static let clientID = "1ceddedc03a5d71"
    
    private init() {}
    
    static func loadCats(onComplete: @escaping (Result<[String], APIError>) -> Void) {
        
        let url = NSURL(string: basePath)
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            if let _ = error {
                onComplete(.failure(.taskError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.badResponse))
                return
            }
            
            if response.statusCode != 200 {
                onComplete(.failure(.invalidStatusCode(response.statusCode)))
                print(response)
                return
            }
            
            guard let data = data else {
                onComplete(.failure(.noData))
                return
            }
            
            do {
                let cats = try JSONDecoder().decode(Cats.self, from: data)
                print("Total de Gatos:", cats.data.count)
                print("\n")
                
                var catLinks: [String] = []
                
                cats.data.forEach({
                    print("CAT >>>", $0.title)
                    
                    if let images = $0.images {
                    
                        images.forEach({
                            if $0.type.split(separator: "/")[0] == "image" && $0.type.split(separator: "/")[1] != "gif" {
                                catLinks.append($0.link)
                            }
                        })
                    }
                })
                
                onComplete(.success(catLinks))
            } catch {
                print(data)
                onComplete(.failure(.invalidJSON))
            }
        }
        
        task.resume()
    }
}
