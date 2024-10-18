//
//  Movie.swift
//  TrendMovie
//
//  Created by Nurlan Darzhanov on 17.10.2024.
//

import Foundation

struct Movie: Codable {
    let title: String
    let year: Int?
    let imdbID: String

    enum CodingKeys: String, CodingKey {
        case title
        case year
        case imdbID = "imdb_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        
        // Попытка декодировать year как строку, если не получится, декодируем как число и конвертируем в строку
        if let yearInt = try? container.decode(Int.self, forKey: .year) {
            self.year = yearInt
        } else if let yearString = try? container.decode(String.self, forKey: .year) {
            self.year = Int(yearString)
        } else {
            self.year = nil
        }
        
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
    }
}


struct MovieSearchResponse: Codable {
    let movieResults: [Movie]
    let searchResults: Int
    let status: String
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case searchResults = "search_results"
        case status
        case statusMessage = "status_message"
    }
}



struct MovieResults: Codable {
    let movieResults: [Movie]
    let results: Int
    let totalResults: String
    let status: String
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case results
        case totalResults = "Total_results"
        case status
        case statusMessage = "status_message"
    }
}
