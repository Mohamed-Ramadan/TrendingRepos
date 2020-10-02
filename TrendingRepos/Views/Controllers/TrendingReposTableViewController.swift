//
//  TrendingReposTableViewController.swift
//  TrendingRepos
//
//  Created by macbook on 10/1/20.
//  Copyright © 2020 Mohamed Ramadan. All rights reserved.
//

import UIKit

enum SortType {
    case name
    case stars
}

class TrendingReposTableViewController: UITableViewController, isInternet {
    
    let loadingCellId = "LoadingTableViewCell"
    let repositoryCellId = "RepositoryTableViewCell"
    
    var isLoading: Bool = true
    var isErrorHappened: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup ui
        self.setupUI()
        
        // register table view cell
        self.setupTableView()
        
        // check internet connection
        Helper.checkInternetConnection(isConnected: self)
        
        // Data callback
        getData()
    }
    
    // MARK: - Internet Check Delegate
    func isConnected(connected: Bool) {
        if connected {
            // load trending repositories form server
            TrendingReposVM.shared.getTrendingRepos(Params: [:])
        } else {
            self.isLoading = false
            self.isErrorHappened = true
            self.setErrorHandlerView()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Class Methods
    private func setupUI() {
        self.title = "Trending"
        
        // adding more button
        let moreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        moreButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        moreButton.addTarget(self, action: #selector(didClickMoreButon), for: .touchUpInside)
        let moreBarButton = UIBarButtonItem(customView: moreButton)
        self.navigationItem.rightBarButtonItems = [moreBarButton]
        
        // configure refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func didClickMoreButon(_ sender:AnyObject) {
        Alerts.showActionsheet(viewController: self, title: "Sort By", message: nil, actions: [("Name", .default), ("Stars", .default), ("Cancel", .cancel)]) { (index) in
            if index == 0 {
                TrendingReposVM.shared.sortRepositoriesBy(.name)
            } else if index == 1 {
                TrendingReposVM.shared.sortRepositoriesBy(.stars)
            }
        }
    }
    
    @objc func refresh(_ sender:AnyObject) {
        self.isLoading = true
        self.tableView.reloadData()
        
        TrendingReposVM.shared.reformatData()
        Helper.checkInternetConnection(isConnected: self)
    }
    
    private func setupTableView() {
        let loadingNib = UINib(nibName: loadingCellId, bundle: nil)
        self.tableView.register(loadingNib, forCellReuseIdentifier: loadingCellId)
        
        let repositoryNib = UINib(nibName: repositoryCellId, bundle: nil)
        self.tableView.register(repositoryNib, forCellReuseIdentifier: repositoryCellId)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 143
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setErrorHandlerView() {
        self.tableView.setEmptyMessage("Something went wrong..", description: "An alient is probably blocking you signal!", image: #imageLiteral(resourceName: "nointernet_connection"), heightFromTop: 30, withAddButton: true, buttonTitle: "RETRY") {
            self.isLoading = true
            self.isErrorHappened = false
            self.tableView.reloadData()
            Helper.checkInternetConnection(isConnected: self)
        }
        self.tableView.reloadData()
    }
    
    private func getData() {
        // Trending repositories closure call back
        TrendingReposVM.shared.reposCompleationHandler = {
            self.isLoading = false
            self.isErrorHappened = false
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
        TrendingReposVM.shared.compleationHandlerWithError = {
            self.isLoading = false
            self.isErrorHappened = true
            self.setErrorHandlerView()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !isErrorHappened {
            tableView.restore()
        } else {
            return 0
        }
        
        return isLoading ? 10 : TrendingReposVM.shared.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            
            // Configure the cell...
            cell.selectionStyle = .none
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: repositoryCellId, for: indexPath) as? RepositoryTableViewCell else {
                return UITableViewCell()
            }
            
            // Configure the cell...
            cell.selectionStyle = .none
            cell.repository = TrendingReposVM.shared.repositories[indexPath.row]
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLoading ? 75 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle expand and collapse repository
        TrendingReposVM.shared.handleExpandeAndCollapseTappedRepoAt(index: indexPath.row)
    }
}
