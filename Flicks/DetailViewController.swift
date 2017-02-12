//
//  DetailViewController.swift
//  Flicks
//
//  Created by Aristotle on 2017-02-05.
//  Copyright © 2017 HLPostman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overviewLabelScrollView: UIScrollView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    var cast: [NSDictionary]?
    
    func castNetworkRequest(movieId: Int) -> URLSessionTask {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.cast = (dataDictionary["cast"] as! [NSDictionary])
                    self.castCollectionView.reloadData()
                }
            }
        }
        print(task)
        MBProgressHUD.hide(for: self.view, animated: true)
        return task 
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadshotCell", for: indexPath as IndexPath) as! HeadshotCell
        if let castMember = cast?[indexPath.row] {
            if let movieId = movie["id"] {
                print("WE GOT AN ID BUY THE VANILLA! 🍌🍌🍌🍌🍌🍌🍌🍌\(movieId)🍌🍌🍌🍌🍌🍌🍌🍌)")//\(castMemberName)🍌")
                // Get and load cast member headshot
                if let headshotPath = castMember["profile_path"] as? String {
                    let headshotBaseURL = "https://image.tmdb.org/t/p/w500/"
                    let headshotURL = NSURL(string: headshotBaseURL + headshotPath)
                    cell.headshotImageView.setImageWith(headshotURL as! URL)
                }
                // Get and place cast member name
                let castMemberName = castMember["name"] as? String ?? "Error fetching name"
                cell.actorNameLabel.text = castMemberName
            }
                
        } else {
            print("You didn't get castMember from cast![indexPath.row] 😒 💗")
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        castCollectionView.dataSource = self
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        scrollView.contentSize.height = 950
        // Instead of setting overview label number of lines to 0, calculate the number of lines
        // for each overview, so that this information can be used in setting the content size
        // for the overview label scroll view.  This way, any long description has a sufficient
        // content size, and the text of short descriptions never scrolls completely out of view
        // as it will when the content size is much larger than the label.
        overviewLabel.numberOfLines = ((movie["overview"] as? String)?.characters.count)! / 30
        let overviewScrollHeight = overviewLabel.font.pointSize * CGFloat(overviewLabel.numberOfLines)
        print("OverviewScrollHeight = \(overviewScrollHeight) and num lines is \(overviewLabel.numberOfLines) and font point size is \(overviewLabel.font.pointSize)")
        overviewLabelScrollView.contentSize.height =  overviewScrollHeight
        // Set poster background
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseURL = "https://image.tmdb.org/t/p/w500/"
            let posterURL = NSURL(string: posterBaseURL + posterPath)
            posterImageView.setImageWith(posterURL as! URL)
        }
        // Set title and overview text
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        // Do any additional setup after loading the view.
        print("You clicked \(title!)🎥")
        if let movieId = movie["id"] as? Int {
            print("💖MovieId: \(movieId)💛")
            let task = castNetworkRequest(movieId: movieId)
            task.resume()
        } else {
            print("💖NO MOVIEID💛")
        }
//        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
