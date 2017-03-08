/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


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
        let strings = try iTunesAPI.parseResponseToImageUrls(data!)
        DispatchQueue.main.async {
          completion(strings)
        }
      } catch {
        fatalError("Could not fetch/parse image urls from the server")
      }
    }
    
    task.resume()
  }
  
  static func parseResponseToImageUrls(_ responseData: Data) throws -> [String] {
    let dictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
    let array = dictionary?["results"] as? [[String: AnyObject]]
    
    let strings = array!.map { (dictionary) -> String in
      return dictionary["artworkUrl100"] as! String
    }
    
    return strings
  }
}


