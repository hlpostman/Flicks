//
//  DetailViewController.swift
//  Flicks
//
//  Created by Aristotle on 2017-02-05.
//  Copyright © 2017 HLPostman. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
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
        
        // Do any additional setup after loading the view.
        print("You clicked \(title!)🎥")
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
