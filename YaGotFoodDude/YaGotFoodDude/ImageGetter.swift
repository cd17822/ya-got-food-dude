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
            } else {
                cb(nil)
            }
        }
    }
    
    private static func downloadImage(_ url: String, _ cb: @escaping (UIImage?) -> ()) {
        let catPictureURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    cb(image)
                } else {
                    print("Couldn't get image: Image is nil")
                    cb(nil)
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    private static func initialQuery(_ query: String, _ cb: @escaping (String?) -> ()) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
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
                            if goodUrl == nil && hits.count > 0 {
                                goodUrl = hits[0]["webformatURL"] as? String
                            }
                        }
                    }
                    print(goodUrl ?? "no good pic for \(query) (\(url))")
                    cb(goodUrl)
                }catch let error as NSError {
                    print(error)
                }
            }
        })
        
        task.resume()
    }
}
