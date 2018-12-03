//
//  RepositoryInfoCell.swift
//  GithubGraphQL
//
//  Created by Daniel Leclair on 12/1/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

class RepositoryInfoCell: UITableViewCell
{
    static let CellID = "RepositoryInfoCell"
    
    @IBOutlet weak var RepositoryName: UILabel!

    @IBOutlet weak var UserAvatarImage: NetworkUIImageView!
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var RepositoryStarCount: UILabel!
    
    public func Configure(withRepoName repositoryName: String, userName: String, starCount: Int, avatarImageURL: String, completion: @escaping (UIImage) -> ())
    {
        if let url = URL(string: avatarImageURL) {
            UserAvatarImage.SetImage(fromURL: url, completion: completion)
        }
        
        Configure(withRepoName: repositoryName, userName: userName, starCount: starCount)
    }
    
    public func Configure(withRepoName repositoryName: String, userName: String, starCount: Int, avatarImage: UIImage? = nil)
    {
        RepositoryName.text = repositoryName
        UserName.text = userName
        RepositoryStarCount.text = "\(starCount) Stars"
        
        if let avatarImage = avatarImage {
            UserAvatarImage.image = avatarImage
        }
    }
    
    public override func prepareForReuse() {
        RepositoryName.text = nil
        UserName.text = nil
        RepositoryStarCount.text = nil
        UserAvatarImage.image = nil
        UserAvatarImage.task?.cancel()
    }
}
