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
    
    var imdbID: String!
    var movie: Movie?
    
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

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getMovie(with: self.imdbID)
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Get movie
    
    func getMovie(with id: String) {
        
        APIManager.shared.getMovie(by: id, completionHandler: getMovieCompletionHandler, errorHandler: nil)
    }
    
    /// Get movie using its id
    func getMovieCompletionHandler(movie: Movie?) {
        
        if let movie = movie {
            
            self.movie = movie
            initMovieDetails()
        }
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Initialize content of the view
    
    func initContent() {
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.navigationBar.tintColor = Colors.customGreen
        self.navigationController?.title = "Details"
    }
    
    func initMovieDetails() {
        
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
