//
//  RepositoryRequestManager.swift
//  GithubGraphQL
//
//  Created by Daniel Leclair on 12/2/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

protocol RepositoryFetchResultDelegate: class
{
    func didFetchResults(repositories: [RepositoryDetails])
}

typealias PageInfo = SearchRepositoriesQuery.Data.Search.PageInfo

class RepositoryRequestManager
{
    var mostRecentPageInfo: PageInfo?
    weak var delegate: RepositoryFetchResultDelegate?
    
    private struct Constants
    {
        static let BatchSize = 10
        static let QueryText = "graphql"
    }
    
    func FetchNextBatch() {
        
        //Initial query
        let gqlQuery: SearchRepositoriesQuery
        
        if mostRecentPageInfo == nil {
            gqlQuery = SearchRepositoriesQuery.init(first: Constants.BatchSize, query: Constants.QueryText, type: SearchType.repository)
        } else {
            gqlQuery = SearchRepositoriesQuery.init(first: Constants.BatchSize, after: mostRecentPageInfo!.endCursor, query: Constants.QueryText, type: SearchType.repository)
        }
        
        RepositoriesGraphQLClient.searchRepositories(query: gqlQuery) { (result) in
            switch result {
            case .success(let data):
                if let gqlResult = data {
                    
                    self.mostRecentPageInfo = gqlResult.data?.search.pageInfo

                    if let edges = gqlResult.data?.search.edges {
                        self.delegate?.didFetchResults(repositories: (edges.compactMap({ edge -> RepositoryDetails? in
                            return edge?.node?.asRepository?.fragments.repositoryDetails
                        })))
                    }
                }
            case .failure(let error):
                if let error = error {
                    print(error)
                }
            }
        }
    }
    

}
