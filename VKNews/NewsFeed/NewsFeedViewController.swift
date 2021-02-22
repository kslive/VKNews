//
//  NewsFeedViewController.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

  var interactor: NewsFeedBusinessLogic?
  var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel.init(cells: [])
  
    @IBOutlet weak var table: UITableView!
    
    // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    let router                = NewsFeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    table.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.reuseID)
    
    interactor?.makeRequest(request: .getNewsFeed)
  }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayNewsFeed(feedViewModel: let feedViewModel):
        self.feedViewModel = feedViewModel
        table.reloadData()
    }
  }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseID, for: indexPath) as! NewsFeedCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
}
