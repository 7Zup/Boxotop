//
//  Home.swift
//  Boxotop
//
//  Created by Fabrice Froehly on 16/01/2018.
//  Copyright © 2018 Fabrice Froehly. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
}





/// Manage elements in the Home view
class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: Movies?
    var page: Int = 1
    
    // Avoid bad request
    var allowPagination: Bool = true
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Initialize content view
    
    func initContent() {
        
        self.searchBar.delegate = self
        
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // Hide edge of search bar
        self.searchBar.backgroundImage = UIImage()
        
        // Refresh the list for the first time
        refreshMovieList(search: nil)
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Get movies from API
    
    func refreshMovieList(search: String?) {
        
        guard self.page <= 100 else {
            
            return
        }
        
        self.allowPagination = false
        
        if let search = search, search != "" {
            
            APIManager.shared.getMoviesBySearch(search: search.lowercased() + "&type=movie", page: self.page, completionHandler: getMoviesCompletionHandler, errorHandler: getMoviesErrorHandler)
        } else {
            
            APIManager.shared.getMoviesBySearch(search: "batman&type=movie", page: self.page, completionHandler: getMoviesCompletionHandler, errorHandler: getMoviesErrorHandler)
        }
    }
    
    func getMoviesCompletionHandler(movies: Movies?) {
        
        // Block/Allow pagination if the request works/fails
        if movies != nil {
            
            self.allowPagination = true
        } else {
            
            self.allowPagination = false
        }
        
        // If it is a new movie list
        if self.page == 1 {
            
            self.movies = movies
            
        } else {
            
            if let currentMovies = self.movies, let newMovies = movies {
                
                currentMovies.movies.append(contentsOf: newMovies.movies)
                if let totalResults = newMovies.totalResults {
                    
                    currentMovies.totalResults = totalResults
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getMoviesErrorHandler(error: Error?) {
        
        // Block pagination if the request fails
        self.allowPagination = false
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = self.movies {
            
            return movies.movies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        
        if let movies = self.movies,
            movies.movies.count > indexPath.row,
            let titleMovie = movies.movies[indexPath.row].title,
            let url_poster = movies.movies[indexPath.row].poster {
            
            cell.titleLabel.text = titleMovie
            
            cell.imageLabel.sd_setImage(with: URL(string: url_poster), placeholderImage: UIImage(named: "tv-picture"))
        }
        
        
        // Background color of cell
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = Colors.customLightGreen
        } else {
            
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let movies = self.movies {
         
            if indexPath.row + 1 == movies.movies.count {
                
                // If pagination is allowed, make request
                if self.allowPagination == true {
                    
                    self.page = self.page + 1
                    self.refreshMovieList(search: self.searchBar.text)
                }
            }
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.page = 1
        self.allowPagination = true
        self.refreshMovieList(search: self.searchBar.text)
        searchBar.resignFirstResponder()
    }
}
