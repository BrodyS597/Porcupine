//
//  SearchViewModel.swift
//  Porcupine
//
//  Created by Brody Sears on 3/1/24.
//

import SwiftUI
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var searchResults: [FlickrItem] = []
    @Published var isLoading: Bool = false
    
    private let networkManager = NetworkManager.shared
    
    func searchImages() {
        isLoading = true
        networkManager.fetchImages(for: searchTerm) { [weak self] images, error in
            DispatchQueue.main.async {
                if let images = images {
                    self?.isLoading = false
                    self?.searchResults = images
                }
            }
        }
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        completion(image)
                    } else {
                        completion(nil)
                    }
                } catch {
                    completion(nil)
                }
            }
        }
    }
