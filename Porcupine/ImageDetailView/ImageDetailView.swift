//
//  ImageDetailView.swift
//  Porcupine
//
//  Created by Brody Sears on 3/1/24.
//

import SwiftUI

struct ImageDetailView: View {
    @State private var viewModel: ImageDetailViewModel

    init(viewModel: ImageDetailViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var formattedDate: String {
        PublishedDateFormatter.formattedDate(from: viewModel.flickrItem.published)
    }

    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Text("Failed to load image")
            }
            Text("Title: \(viewModel.flickrItem.title)")
                .padding()
            Text("Description: \(viewModel.flickrItem.description)")
                .padding()
            Text("Author: \(viewModel.flickrItem.author)")
                .padding()
            Text("Publish Date: \(formattedDate)")
                .padding()
        }
    }
}

// MARK: - Date Formatter

struct PublishedDateFormatter {
    static func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            dateFormatter.timeZone = TimeZone.current 
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
