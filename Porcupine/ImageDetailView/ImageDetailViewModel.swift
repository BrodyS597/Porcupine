//
//  ImageDetailViewModel.swift
//  Porcupine
//
//  Created by Brody Sears on 3/1/24.
//

import SwiftUI

class ImageDetailViewModel: ObservableObject {
    @Published var flickrItem: FlickrItem
    @Published var image: UIImage?
    @Published var isLoading: Bool = false

    init(flickrItem: FlickrItem, image: UIImage?) {
        self.flickrItem = flickrItem
        self.image = image
    }
}
