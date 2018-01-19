//
//  MovieDetails.swift
//  Boxotop
//
//  Created by Fabrice Froehly on 18/01/2018.
//  Copyright © 2018 Fabrice Froehly. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStarRatingView

/// This class will display all information about a movie
class MovieDetailsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var imdbRating: SwiftyStarRatingView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imdbID: String!
    var movie: Movie?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getMovie(with: self.imdbID)
        
        // Hide toolbar
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide toolbar
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.contentSize.height = 700
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Get movie
    
    func getMovie(with id: String) {
        
        // Get the information about the current movie
        APIManager.shared.getMovie(by: id, completionHandler: getMovieCompletionHandler, errorHandler: nil)
    }
    
    /// Use the Movie object received from the server
    func getMovieCompletionHandler(movie: Movie?) {
        
        if let movie = movie {
            
            self.movie = movie
            initMovieDetails()
        }
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Initialize content of the view
    
    func initContent() {
        
        // Colors and text and the navigation bar
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Colors.customGreen
        self.title = "Details"
        self.navigationController?.navigationBar.backgroundColor = Colors.customGreen//titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.customGreen]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Scroll the textview to the top
        self.synopsisTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func initMovieDetails() {
        
        // Check and use each value of the Movie model
        if let movie = self.movie {
            
            if let title = movie.title {
                
                self.titleLabel.text = title
            }
            
            if let poster = movie.poster {
                
                self.posterImageView.sd_setImage(with: URL(string: poster), placeholderImage: UIImage(named: "tv-picture"))
            }

            if let releaseDate = movie.released {
                
                self.releaseDate.text = releaseDate
            }
            
            if let imdbRating = movie.imdbRating {
                
                if let number = NumberFormatter().number(from: imdbRating) {

                    // Rating imdb is on 10pts, since the rating library works on 5pts, we ave to devide by 2
                    self.imdbRating.value = CGFloat(truncating: number) / 2
                }
            }
            
            if let runtime = movie.runtime {
                
                self.runtimeLabel.text = runtime
            }
            
            if let genre = movie.genre {
                
                self.genreLabel.text = genre
            }
            
            if let director = movie.director {
                
                self.directorLabel.text = director
            }
            
            if let actors = movie.actors {
                
                self.actorsLabel.text = actors
            }
            
            if let writer = movie.writer {
                
                self.writerLabel.text = writer
            }
            
            if let synopsis = movie.plot {
                
                self.synopsisTextView.text = synopsis
            }
        }
    }
}
