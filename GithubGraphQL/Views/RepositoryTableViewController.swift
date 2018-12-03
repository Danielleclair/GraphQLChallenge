//
//  RepositoryTableViewController.swift
//  GithubGraphQL
//
//  Created by Daniel Leclair on 12/1/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTableViewController: UITableViewController, RepositoryFetchResultDelegate
{
    var repositoryRequestManager: RepositoryRequestManager!
    var activityIndicator: UIActivityIndicatorView?
    var repositoryList: [RepositoryDetails] = []
    var fetchingNextPage: Bool = false
    
    override func viewDidLoad() {
        repositoryRequestManager = RepositoryRequestManager()
        repositoryRequestManager.delegate = self
        repositoryRequestManager.FetchNextBatch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.CellID) as? RepositoryInfoCell
        let repo = repositoryList[indexPath.row]
        
        cell!.Configure(withRepoName: repo.name, userName: repo.owner.login, starCount: repo.stargazers.totalCount, avatarImageURL: repo.owner.avatarUrl)
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryList.count
    }
    
    private func showActivityIndicator() {
    
        if activityIndicator == nil {
            createActivityIndicator()
        }
        
        activityIndicator!.startAnimating()
        activityIndicator!.isHidden = false
    }
    
    private func hideActivityIndicator() {
        
        if activityIndicator == nil {
            createActivityIndicator()
        }
        
        activityIndicator!.isHidden = true
        activityIndicator!.stopAnimating()
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !fetchingNextPage && scrollView.contentOffset.y >= scrollView.contentSize.height / 2 {
            fetchingNextPage = true
            repositoryRequestManager.FetchNextBatch()
        }
    }
    
    func didFetchResults(repositories: [RepositoryDetails]) {
        
        fetchingNextPage = false
        var insertIndicies: [IndexPath] = []
        
        for index in 0..<repositories.count {
            insertIndicies += [IndexPath(row: self.repositoryList.count + index, section: 0)]
        }
        
        self.repositoryList += repositories
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: insertIndicies, with: .fade)
            self.tableView.endUpdates()
        }
    }
}
