//
//  RepositoryTableViewController.swift
//  GithubGraphQL
//
//  Created by Daniel Leclair on 12/1/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

internal class RepositoryTableViewController: UITableViewController
{
    override func viewDidLoad() {
    }
    
    var currentOffset = 0;
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.CellID) as? RepositoryInfoCell
        
//        cell?.RepositoryName.text = "TEST"
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e3/User_Avatar_Person_Info_Information-512.png")
        
        
       cell?.UserAvatarImage.SetImage(fromURL: url!)
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
