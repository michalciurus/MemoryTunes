//
//  iTunesAPI.swift
//  MemoryTunes
//
//  Created by Michal Ciurus on 31/01/17.
//  Copyright © 2017 raywenderlich. All rights reserved.
//

import Foundation

final class iTunesAPI {
    static func searchFor(category: String, completion: @escaping ([String]) -> Void) {
        
        let urlString = "https://itunes.apple.com/search?term=\(category)&media=music"
        let urlRequest: URLRequest = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            //TODO: React on errors
            guard error == nil else {
                completion([])
                return
            }
            
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                let array = dictionary?["results"] as? [[String: AnyObject]]
                if let array = array {
                    let strings = array.map { (dictionary) -> String in
                        return dictionary["artworkUrl100"] as! String
                    }
                    
                    DispatchQueue.main.async {
                        completion(strings)
                    }
                }
            } catch {
                fatalError("Could not fetch/parse image urls from the server")
            }
        }
        
        task.resume()
    }
}
