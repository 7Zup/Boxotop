//
//  BoxotopTests.swift
//  BoxotopTests
//
//  Created by Fabrice Froehly on 16/01/2018.
//  Copyright © 2018 Fabrice Froehly. All rights reserved.
//

import XCTest
import Foundation
import UIKit
@testable import Boxotop

class MovieTests: XCTestCase {
    
    // List of movies
    var movies: Movies?
    
    // Single movie
    var movie: Movie?
    
    // Timer
    var exp: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Enable the waiting part
        self.exp = expectation(description: "\(#function)\(#line)")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Get one movie
    
    func test_a_getOneMovie() {
        
        let id: String = "tt3896198"
        let title: String = "Guardians of the Galaxy Vol. 2"
        
        // get/create user
        APIManager.shared.getMovie(by: id, completionHandler: getMovieCompletionHandler, errorHandler: nil)
        
        // Wait for asynchronous functions to finish
        waitForExpectations(timeout: 10, handler: nil)
        
        // Test if the title received is the same
        XCTAssertEqual(title, self.movie?.title)
    }
    
    /// Completion called when the get movie call had succeeded
    ///
    /// - Parameter user: The movie returned by the API call
    func getMovieCompletionHandler(movie: Movie?) {
        
        if let movie = movie {
            
            self.movie = movie
            exp.fulfill()
        } else {
            
            // If movie is nil
            XCTFail("Error: MovieTests - Couldn't get movie")
        }
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Get movie list
    
    func test_b_getMovieList() {
        
        let searchText = "batman"
        let page = 1
        let title: String = "Batman Begins"
        
        // get/create user
        APIManager.shared.getMoviesBySearch(search: searchText, page: page, completionHandler: getMovieListCompletionHandler, errorHandler: nil)
        
        // Wait for asynchronous functions to finish
        waitForExpectations(timeout: 10, handler: nil)
        
        // Test if the title received is the same
        // Here filter gets the list in order according to our title var, then it fetches the first elem of the list
        XCTAssertEqual(title, self.movies?.movies.filter({ $0.title ?? "" == title }).first?.title)
    }
    
    /// Completion called when the get movies call had succeeded
    ///
    /// - Parameter user: The list of movies returned by the API call
    func getMovieListCompletionHandler(movies: Movies?) {
        
        if let movies = movies {
            
            self.movies = movies
            exp.fulfill()
        } else {
            
            // If movies is nil
            XCTFail("Error: MovieTests - Couldn't get movies list")
        }
    }
    
}
