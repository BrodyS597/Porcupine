//
//  SearchView.swift
//  Porcupine
//
//  Created by Brody Sears on 3/1/24.
//

import SwiftUI

// MARK: - SearchView

struct SearchView: View {
    @State private var isSearching = false
    @ObservedObject private var viewModel = SearchViewModel()
    @State private var searchTerm = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(isSearching: $viewModel.isLoading, searchTerm: $searchTerm, viewModel: viewModel)
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    GridView(images: viewModel.searchResults, fetchImage: viewModel.fetchImage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()
                PorcupineView()
            }
            .padding()
            .onAppear {
                viewModel.searchTerm = searchTerm
                viewModel.searchImages()
            }
        }
    }
}

// MARK: - SearchBar

struct SearchBar: View {
    @Binding var isSearching: Bool
    @Binding var searchTerm: String
    let viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchTerm)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                .overlay(
                    HStack {
                        Spacer()
                        if isSearching {
                            ProgressView()
                                .padding(.trailing, 25)
                        }
                    }
                )
                .padding(.horizontal)
                .onChange(of: searchTerm) { newSearchTerm, _ in
                    viewModel.searchTerm = searchTerm
                    isSearching = !searchTerm.isEmpty
                    viewModel.searchImages()
                }
        }
    }
}

// MARK: - GridView

struct GridView: View {
    let images: [FlickrItem]
    let fetchImage: (String, @escaping (UIImage?) -> Void) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                ForEach(images, id: \.link) { item in
                    AsyncImage(urlString: item.media.m, fetchImage: fetchImage, flickrItem: item)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// MARK: - AsyncImage

struct AsyncImage: View {
    let urlString: String
    let fetchImage: (String, @escaping (UIImage?) -> Void) -> Void
    @State private var isShowingDetail = false
    @State private var image: UIImage?
    let flickrItem: FlickrItem?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    isShowingDetail = true
                }
                .sheet(isPresented: $isShowingDetail) {
                    if let flickrItem = flickrItem {
                        ImageDetailView(viewModel: .init(flickrItem: flickrItem, image: image))
                    }
                }
        } else {
            ProgressView()
                .onAppear {
                    fetchImage(urlString) { fetchedImage in
                        DispatchQueue.main.async {
                            self.image = fetchedImage
                        }
                    }
                }
        }
    }
}

// MARK: - PorcupineView

struct PorcupineView: View {
    var body: some View {
        HStack {
            Text("Porcupine")
                .font(.custom("AvenirNext-HeavyItalic", size: 24))
            Image("Porcupine")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    SearchView()
}
