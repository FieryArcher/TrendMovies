//
//  MovieCatalogViewController.swift
//  TrendMovie
//
//  Created by Nurlan Darzhanov on 17.10.2024.
//

import UIKit

class MovieCatalogViewController: UIViewController {

    
    var collectionView: UICollectionView!
    var movies: [Movie] = []
    let searchBar = UISearchBar()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var loadingOverlay: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        
        NetworkManager.shared.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    print("Movies count: \(movies.count)")
                    // Здесь можно обновить collectionView или tableView
                     self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchBar.delegate = self
        searchBar.placeholder = "Search for movies"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        view.addSubview(collectionView)
    }
    

    func showLoadingOverlay() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        
        view.addSubview(overlay)
        
        loadingOverlay = overlay
    }

    func hideLoadingOverlay() {
        loadingOverlay?.removeFromSuperview()
        loadingOverlay = nil
    }

    
}

extension MovieCatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = movies[indexPath.item]
        let cntrl = MovieDetailsController()
        
        cntrl.movie = cell
        self.navigationController?.pushViewController(cntrl, animated: true)
        // do stuff with image, or with other data that you need
    }
}

extension MovieCatalogViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchMovies(query: query)
        searchBar.resignFirstResponder() // Закрываем клавиатуру
    }
    
    // Выполняем запрос на получение фильмов по названию
    private func searchMovies(query: String) {
        showLoadingOverlay()
        NetworkManager.shared.searchMoviesByTitle(title: query) { result in
            DispatchQueue.main.async {
                self.hideLoadingOverlay()
                switch result {
                case .success(let movieResults):
                    self.movies = movieResults
                    self.collectionView.reloadData() // Обновляем collection view
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }
}
