//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepository:GithubRepository = self.store.repositories[indexPath.row]
        
        let githubStarAlert = UIAlertController.init(title: "Github Star Status", message: "testing", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        githubStarAlert.addAction(defaultAction)
        
        
        ReposDataStore.toggleStarStatusForRepository(selectedRepository, completion: { (starred) in
            
            if starred {
                githubStarAlert.message = "You just unstarred \(selectedRepository.fullName)"
                githubStarAlert.accessibilityLabel = githubStarAlert.message
            } else {
                githubStarAlert.message = "You just starred \(selectedRepository.fullName)"
                githubStarAlert.accessibilityLabel = githubStarAlert.message
            }
            
            
        })
        
        self.presentViewController(githubStarAlert, animated: true, completion: nil)
        
        

        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }

}
