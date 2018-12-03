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
    var avatarImages: [String : UIImage] = [:]
    var fetchingNextPage: Bool = false
    
    override func viewDidLoad() {
        repositoryRequestManager = RepositoryRequestManager()
        repositoryRequestManager.delegate = self
        showActivityIndicator()
        repositoryRequestManager.FetchNextBatch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.CellID) as? RepositoryInfoCell
        let repo = repositoryList[indexPath.row]
        
        if let avatarImage = avatarImages[repo.owner.avatarUrl] {
            cell!.Configure(withRepoName: repo.name, userName: repo.owner.login, starCount: repo.stargazers.totalCount, avatarImage: avatarImage)
        } else {
            cell!.Configure(withRepoName: repo.name, userName: repo.owner.login, starCount: repo.stargazers.totalCount, avatarImageURL: repo.owner.avatarUrl) { [weak self] avatarImage in
                    self?.avatarImages[repo.owner.avatarUrl] = avatarImage
                }
        }
        
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
        
        DispatchQueue.main.async {
            self.activityIndicator!.startAnimating()
            self.activityIndicator!.isHidden = false
        }
    }
    
    private func hideActivityIndicator() {
        
        if activityIndicator == nil {
            createActivityIndicator()
        }
        
        DispatchQueue.main.async {
            self.activityIndicator!.isHidden = true
            self.activityIndicator!.stopAnimating()
        }
    }
    
    private func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator!)
        
        NSLayoutConstraint.activate([
            activityIndicator!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !fetchingNextPage && scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
            fetchingNextPage = true
            showActivityIndicator()
            repositoryRequestManager.FetchNextBatch()
        }
    }
    
    func didFetchResults(repositories: [RepositoryDetails]) {
        
        hideActivityIndicator()
        var insertIndicies: [IndexPath] = []
        
        for index in 0..<repositories.count {
            insertIndicies += [IndexPath(row: self.repositoryList.count + index, section: 0)]
        }
        
        self.repositoryList += repositories
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.fetchingNextPage = false
        }
    }
}
