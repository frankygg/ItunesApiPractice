//
//  DownLoad.swift
//  ItunesApiPractice
//
//  Created by BoTingDing on 2018/7/7.
//  Copyright © 2018年 BoTingDing. All rights reserved.
//

import Foundation

class Download {
    static let download = Download()
    
    func requestWithURL(searchText: String, completion: @escaping ([ItunesData]) -> Void){
        
        let expectedCharSet = NSCharacterSet.urlQueryAllowed
        let searchTerm = searchText.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")
        
        guard let queryedURL = url else{return}
        
        let request = URLRequest(url: queryedURL)
        
        fetchedDataByDataTask(from: request, completion: completion)
    }
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping ([ItunesData]) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{return}
                do {
                    if let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                        var searchResults = [ItunesData]()
                        // Get the results array
                        if let array: AnyObject = response["results"] {
                            for trackDictonary in array as! [AnyObject] {
                                if let trackDictonary = trackDictonary as? [String: AnyObject], let previewUrl = trackDictonary["previewUrl"] as? String {
                                    // Parse the search result
                                    let name = trackDictonary["trackName"] as? String
                                    let artist = trackDictonary["artistName"] as? String
                                    let artworkUrl60 = trackDictonary["artworkUrl60"] as? String
                                    let collectionName = trackDictonary["collectionName"] as? String
                                    searchResults.append(ItunesData(trackName: name, artistName: artist, previewUrl: previewUrl, artworkUrl60: artworkUrl60, collectionName: collectionName))
                                } else {
                                    print("Not a dictionary")
                                }
                            }
                            completion(searchResults)
                        } else {
                            print("Results key not found in dictionary")
                        }
                    } else {
                        print("JSON Error")
                    }
                } catch let error as NSError {
                    print("Error parsing results: \(error.localizedDescription)")
                }
//                completion(data)
            }
        }
        task.resume()
    }
    
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = URL(string: previewUrl) {
            //      , let lastPathComponent = url.lastPathComponent
            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
}
