//
//  NetworkService.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/21/22.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol{
    func searchTracksBy(request: String, complition: @escaping (Result<SearchResponse?, Error>) -> Void)
    func getImageBy(urlString: String?, complition: @escaping (Result<UIImage?, Error>) -> Void)
    func getTrackBy(urlString: String?, complition: @escaping (Result<Data?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func searchTracksBy(request: String, complition: @escaping (Result<SearchResponse?, Error>) -> Void) {
        
        let urlString = "https://itunes.apple.com/search?term=\(request)&limit=35"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode(SearchResponse.self, from: data!)
                complition(.success(obj))
            } catch {
                complition(.failure(error))
            }
        }.resume()
    }
    
    func getImageBy(urlString: String?, complition: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            let image = UIImage(data: data!)
            complition(.success(image))
        }.resume()
    }
    
    func getTrackBy(urlString: String?, complition: @escaping (Result<Data?, Error>) -> Void) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            complition(.success(data))
        }.resume()
    }
}
