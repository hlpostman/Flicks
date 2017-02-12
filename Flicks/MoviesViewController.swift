//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Aristotle on 2017-01-29.
//  Copyright © 2017 HLPostman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var networkingErrorView: UITableView!
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint: String!
    
    func makeNetworkRequest(endpoint: String) -> URLSessionTask {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.networkingErrorView.isHidden = true
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    // So that we get something on launch set self.filteredMovies to the
                    // self.movies array pulled by the network request
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                }
            }
            else {
                self.networkingErrorView.isHidden = false
                MBProgressHUD.showAdded(to: self.networkingErrorView, animated: true)
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
        return task
    }
    
    func getPosterURL(id: Int) -> NSURL? {
        let movie = self.filteredMovies![id] as NSDictionary
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
            let posterURL = NSURL(string: posterBaseURL + posterPath)
            return posterURL
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.networkingErrorView.isHidden = true
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Movie Titles..."
        
//        tableView.allowsSelection = false
        
        // Make GET request to the "Now Playing" endpoint of The Movie Database API
        let task = makeNetworkRequest(endpoint: endpoint)
        task.resume()
        
    }
    
    
    func refreshControlAction (refreshControl: UIRefreshControl) {
        let task = makeNetworkRequest(endpoint: endpoint)
        refreshControl.endRefreshing()
        task.resume()
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as? String ?? "Error fetching title"
        let overview = movie["overview"] as? String ?? "Error fetching overview"
        if let posterURL = getPosterURL(id: (indexPath.row)) {
            cell.posterImageView.setImageWith(posterURL as URL)
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.selectionStyle = .none
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
                filteredMovies = searchText.isEmpty ? movies : movies!.filter({ (movie) -> Bool in
                    return (movie["title"] as! String).lowercased().hasPrefix(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredMovies![(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        detailViewController.hidesBottomBarWhenPushed = true
    }
 
    
}
