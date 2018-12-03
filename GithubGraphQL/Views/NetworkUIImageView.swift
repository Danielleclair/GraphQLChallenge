//
//  NetworkUIImageView.swift
//  GithubGraphQL
//
//  Created by Daniel Leclair on 12/2/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

//A subclass of UIImageView that handles the asychronous fetching
//of an image from a URL
class NetworkUIImageView: UIImageView
{
    var task: URLSessionDataTask?
    
    public func SetImage(fromURL url: URL, completion: @escaping (UIImage) -> ()) {
        let urlSession = URLSession.shared
        let urlRequest = URLRequest(url: url)
        
        task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.image = image
                   completion(image)
                }
            }
        }
        
        task!.resume()
    }
}
