//
//  APIManager.swift
//  Boxotop
//
//  Created by Fabrice Froehly on 16/01/2018.
//  Copyright © 2018 Fabrice Froehly. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON

class APIManager {
    
    // Singleton
    static let shared = APIManager()
    
    // Variables
    var access_token: String?
    private let apiURL = "http://www.omdbapi.com/?apikey=4d908c4a&r=json&"
    
//    4d908c4a
//    a84e27a3
    
    
    
    
    // Private because APIController is a singleton
    private init() {}
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - General request to use the API
    
    private func request<T: Mappable>(requestType: HTTPMethod, route: String, params: [String: AnyObject]? = nil, keyPath: String? = nil, retry: Int? = 2, completionHandler: @escaping (_ object: T?) -> Void, errorHandler: ((NSError?) -> Void)?) {
        
        print("request route : \(apiURL)\(route)")
        print("params \(String(describing: params ?? nil))")
        
        Alamofire.request("\(apiURL)\(route)", method: requestType, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseObject(keyPath: keyPath) { (response: DataResponse<T>) in
                
                switch response.result {
                    
                    case .success:
                        
                        completionHandler(response.result.value)
                    case .failure:
                        
                        errorHandler?(response.error as NSError?)
                }
        }
    }
    
    private func requestArray<T: Mappable>(requestType: HTTPMethod, route: String, params: [String: AnyObject]? = nil, keyPath: String? = nil, retry: Int? = 5, completionHandler: @escaping (_ object: [T]?) -> Void, errorHandler: ((NSError?) -> Void)?) {
        
        print("request route : \(apiURL)\(route)")
        print("params \(String(describing: params ?? nil))")
        
        Alamofire.request("\(apiURL)\(route)", method: requestType, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseArray(keyPath: keyPath) { (response: DataResponse<[T]>) in
                
                switch response.result {
                    
                case .success:
                    
                    completionHandler(response.result.value)
                case .failure:
                    
                    errorHandler?(response.error as NSError?)
                }
        }
    }
    
    
    
    
    
    /*****************************************************************************/
    // MARK: - Search Movie
    
    /// Return list of movies using a string
    func getMoviesBySearch(search: String, page: Int, completionHandler: @escaping (_ messages: Movies?) -> Void, errorHandler: ((NSError?) -> Void)?) {
        
        self.request(requestType: .post, route: "s=\(search)&page=\(page)", completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    /// Return list of movies using the id of the movie
    func getMovieById(id: String, completionHandler: @escaping (_ messages: Movie?) -> Void, errorHandler: ((NSError?) -> Void)?) {
        
        self.request(requestType: .post, route: "i=\(id)", completionHandler: completionHandler, errorHandler: errorHandler)
    }
}
