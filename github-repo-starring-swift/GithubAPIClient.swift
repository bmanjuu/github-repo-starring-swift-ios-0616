//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) ->()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
            //  githubRequest.addValue("token \(Secrets.token)", forHTTPHeaderField: "Authorization")
            githubRequest.HTTPMethod = "GET"
            
            //   if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode == 204 {
                print("Checking...Repo is Starred!")
                completion(true)
                
            } else {
                print("Checking...Repo is Unstarred!")
                completion(false)
                // print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    
    class func starRepository(fullName: String, completion:()->()){
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
           // githubRequest.addValue("token \(Secrets.token)", forHTTPHeaderField: "Authorization")
            githubRequest.HTTPMethod = "PUT"
            
          //  if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            

                completion()
            
            
        }
        
        task.resume()
        
    }
    
    
    class func unstarRepository(fullName: String, completion: ()->()) {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
       let githubRequest = NSMutableURLRequest(URL: unwrappedURL)
        
        let task = session.dataTaskWithRequest(githubRequest) { (data, response, error) in
          //  githubRequest.addValue("token \(Secrets.token)", forHTTPHeaderField: "Authorization")
            githubRequest.HTTPMethod = "DELETE"
            
           // if let data = data {githubRequest.HTTPBody = NSData(data: data)}
            
                completion()

        }
        
        task.resume()
    }
    
    
}

