//
//  Movie.swift
//  Boxotop
//
//  Created by Fabrice Froehly on 16/01/2018.
//  Copyright © 2018 Fabrice Froehly. All rights reserved.
//

import UIKit
import ObjectMapper


/// Class Movies that contains a list of movies
class Movies: Mappable {
    
    var movies: [Movie]?
    var totalResults: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        movies          <- map["Search"]
        totalResults    <- map["totalResults"]
    }
}





/// Class Movie that contains the information about a movie
class Movie: Mappable {
    
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var poster: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
        title           <- map["Title"]
        year            <- map["Year"]
        imdbID          <- map["imdbID"]
        type            <- map["Type"]
        poster          <- map["Poster"]
    }
}

