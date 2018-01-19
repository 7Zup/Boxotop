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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Hide toolbar
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reveal navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Hide toolbar
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Initialize content view
    
    func initContent() {
        
        self.searchBar.delegate = self
        
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
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueMovieDetails" {
            
            let destVC = segue.destination as! MovieDetailsVC
            
            destVC.imdbID = sender as! String
        }
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
            let yearMovie = movies.movies[indexPath.row].year,
            let url_poster = movies.movies[indexPath.row].poster {
            
            cell.titleLabel.text = titleMovie
            cell.dateLabel.text = yearMovie
            
            cell.posterImageView.sd_setImage(with: URL(string: url_poster), placeholderImage: UIImage(named: "missing-picture"))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var imdbID: String = ""
        
        // Get the imdbID from our movie list
        if let id = self.movies?.movies[indexPath.row].imdbID {
            imdbID = id
        }
        
        // Perform segue and send the id of the movie to the next view controller
        performSegue(withIdentifier: "segueMovieDetails", sender: imdbID)
    }
}

extension HomeVC: UISearchBarDelegate {
    
    // Function triggered when the user uses the search button on its keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Reset pagination
        self.page = 1
        self.allowPagination = true
        
        // Refresh the list of movie accordingly to it search
        self.refreshMovieList(search: self.searchBar.text)
        
        // Close keyboard
        self.searchBar.endEditing(true)
    }
}
