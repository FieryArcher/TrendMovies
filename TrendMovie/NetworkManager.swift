//
//  NetworkManager.swift
//  TrendMovie
//
//  Created by Nurlan Darzhanov on 17.10.2024.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let headers = [
        "X-Rapidapi-Key": "451383f644mshb557d79f0fb263cp196a5cjsn820321efdc79",
        "X-Rapidapi-Host": "movies-tv-shows-database.p.rapidapi.com"
    ]
    
    let tunel = "https://movies-tv-shows-database.p.rapidapi.com"
    
    private init() {}
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        let urlString = tunel+"/?page=1"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.setValue("get-trending-movies", forHTTPHeaderField: "Type")

        let session = URLSession.shared
        print("Starting fetch for trending movies...")

        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let movieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                completion(.success(movieResults.movieResults)) // Передаем массив Movie
            } catch let decodingError {
                completion(.failure(decodingError)) // Обрабатываем ошибку парсинга
            }
        }
        dataTask.resume()
    }
    
    func getMovieById(imdbId: String, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = tunel + "/?movieid=\(imdbId)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.setValue("get-movie-details", forHTTPHeaderField: "Type")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Парсим JSON в модель
            do {
                let movieResponse = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(movieResponse)) // Возвращаем объект фильма
            } catch {
                completion(.failure(error)) // Обрабатываем ошибку парсинга
            }
        }
        dataTask.resume()
    }
    
    func searchMoviesByTitle(title: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: tunel + "/?title=\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.setValue("get-movies-by-title", forHTTPHeaderField: "Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                completion(.success(decodedResponse.movieResults))
            } catch let decodingError {
                print("Error decoding response: \(decodingError)")
                completion(.failure(decodingError))
            }
        }
        dataTask.resume()
    }
    
}


enum NetworkError: Error {
    case invalidURL
    case noData
}
