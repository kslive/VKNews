//
//  FeedViewController.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.12.2020.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.getFeed { (feedResponse) in
            guard let feedresponse = feedResponse else { return }
            feedresponse.items.map({ print($0.date) })
        }
    }
}
