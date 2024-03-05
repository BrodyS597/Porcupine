//
//  NetworkManager.swift
//  Porcupine
//
//  Created by Brody Sears on 3/1/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchImages(for searchTerm: String, completion: @escaping ([FlickrItem]?, Error?) -> Void) {
        // Construct URL based on search term
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchTerm)"
        
        guard let url = URL(string: urlString) else {
             return completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        // Fetch data from API
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(FlickrResult.self, from: data)
                completion(result.items, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

struct FlickrResult: Codable {
    let items: [FlickrItem]
}
