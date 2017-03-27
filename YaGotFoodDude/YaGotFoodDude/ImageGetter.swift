//
//  ImageGetter.swift
//  YaGotFoodDude
//
//  Created by Charles DiGiovanna on 3/24/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import UIKit

class ImageGetter {
    public static func get(_ query: String, cb: @escaping (UIImage?) -> ()) {
        initialQuery(query) { url in // this should be a string but its not
            if url != nil {
                self.downloadImage(url!, cb)
            }
        }
    }
    
    private static func downloadImage(_ url: String, _ cb: @escaping (UIImage?) -> ()) {
        let catPictureURL = URL(string: url)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        // Do something with your image.
                        cb(image)
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    private static func initialQuery(_ query: String, _ cb: @escaping (String?) -> ()) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let urlizedQuery = query.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://pixabay.com/api/?key=4915229-c4d2e0ed2084483a64af60712&q=\(urlizedQuery)&image_type=photo&per_page=10")
        if url == nil {
            print(urlizedQuery)
            return
        }
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    var goodUrl: String?
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let hits = json["hits"] as? [[String: Any]] {
                            for hit in hits {
                                if let previewUrl = hit["previewURL"] as? String {
                                    if previewUrl.contains(query.lowercased().components(separatedBy: " ")[0]) {
                                        goodUrl = hit["webformatURL"] as? String
                                        break
                                    }
                                }
                            }
                        }
                    }
                    print(goodUrl ?? "no good pic")
                    cb(goodUrl)
                }catch {
                    print("errorhomes")
                }
            }
        })
        
        task.resume()
    }
}
