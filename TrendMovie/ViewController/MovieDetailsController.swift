//
//  MovieDetailsController.swift
//  TrendMovie
//
//  Created by Nurlan Darzhanov on 18.10.2024.
//

import UIKit

class MovieDetailsController: UIViewController {

    var movie: Movie?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var movieTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        return lbl
    }()
    
    private lazy var madeLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12, weight: .light)
        return lbl
    }()
    
    private lazy var imdbLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 40, weight: .heavy)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupActivityIndicator()
        if let movieId = movie?.imdbID {
            fetchMovieDetails(movieId: movieId)
        }
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func fetchMovieDetails(movieId: String) {
        activityIndicator.startAnimating()
        
        NetworkManager.shared.getMovieById(imdbId: movieId) { result in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating() // Останавливаем индикатор
                switch result {
                case .success(let movie):
                    self.movie = movie
                    self.setup() // Обновляем UI
                case .failure(let error):
                    print("Error fetching movie: \(error)")
                    // Обработка ошибок, например, показать алерт
                }
            }
        }
    }
    
    
    func setup() {
        
        movieTitle.text = movie?.title
        madeLbl.text = movie?.year.map(String.init) ?? "Unknown Year"
        imdbLbl.text = movie?.imdbID
        
        view.addSubview(movieTitle)
        view.addSubview(madeLbl)
        view.addSubview(imdbLbl)
        
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            movieTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            madeLbl.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 16),
            madeLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            madeLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            imdbLbl.topAnchor.constraint(equalTo: madeLbl.bottomAnchor, constant: 16),
            imdbLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imdbLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
        ])
        
    }
}
