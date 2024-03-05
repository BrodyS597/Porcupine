//
//  SearchViewModelTests.swift
//  PorcupineTests
//
//  Created by Brody Sears on 3/4/24.
//

import XCTest
@testable import Porcupine

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSearchImagesSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Images fetched successfully")

        // When
        viewModel.searchTerm = "dogs"
        viewModel.searchImages()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Validating that isLoading is set to false
            XCTAssertFalse(self.viewModel.isLoading)

            // Validating that searchResults contains images
            XCTAssertFalse(self.viewModel.searchResults.isEmpty)

            // Fulfilling the expectation
            expectation.fulfill()
        }

        // Waiting for the expectation to be fulfilled
        wait(for: [expectation], timeout: 3)
    }
}
