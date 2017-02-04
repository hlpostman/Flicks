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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var networkingErrorView: UITableView!
    var movies: [NSDictionary]?
    
    func makeNetworkRequest() -> URLSessionTask {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.networkingErrorView.isHidden = true
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.tableView.reloadData()
                }
            }
            else {
                self.networkingErrorView.isHidden = false
                MBProgressHUD.showAdded(to: self.networkingErrorView, animated: true)
            }
        }
        print(task)
        MBProgressHUD.hide(for: self.view, animated: true)
        return task
    }
    
    func getPosterURL(id: Int) -> NSURL {
        let movie = self.movies![id] as NSDictionary
        let posterPath = movie["poster_path"] as? String ?? "Error fetching poster_path"
        let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
        let posterURL = NSURL(string: posterBaseURL + posterPath)
        return posterURL!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.networkingErrorView.isHidden = true
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.allowsSelection = false
        
        // Make GET request to the "Now Playing" endpoint of The Movie Database API
        let task = makeNetworkRequest()
        task.resume()
        
    }
    
    func refreshControlAction (refreshControl: UIRefreshControl) {
        let task = makeNetworkRequest()
        refreshControl.endRefreshing()
        task.resume()
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        print(cell.titleLabel?.text ?? "Something went wrong")
        let movie = movies![indexPath.row]
        let title = movie["title"] as? String ?? "Error fetching title"
        let overview = movie["overview"] as? String ?? "Error fetching overview"
        let posterURL = getPosterURL(id: (indexPath.row))
        //        Get poster image URL code, in case the asbtraction to function was a bad idea:
        //        let posterPath = movie["poster_path"] as? String ?? "Error fetching poster_path"
        //        let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
        //        let posterURL = NSURL(string: posterBaseURL + posterPath)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.setImageWith(posterURL as URL)
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
