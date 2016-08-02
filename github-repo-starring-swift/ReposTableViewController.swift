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
        
        
        
        ReposDataStore.toggleStarStatusForRepository(selectedRepository) { (starred) in
            print("In the RepoDataStore function")
            
            let githubStarAlert = UIAlertController.init(title: "", message: "", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            githubStarAlert.addAction(defaultAction)
            
            if starred {
                githubStarAlert.title = "You just unstarred \(selectedRepository.fullName)"
                print("alertMessage: \(githubStarAlert.title)")
                githubStarAlert.accessibilityLabel = "You just unstarred \(selectedRepository.fullName)"
            } else {
                githubStarAlert.title = "You just starred \(selectedRepository.fullName)"
                print("alertMessage: \(githubStarAlert.title)")
                githubStarAlert.accessibilityLabel = "You just starred \(selectedRepository.fullName)"
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.presentViewController(githubStarAlert, animated: true, completion: {
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
            })

        }
        
        
//        self.presentViewController(githubStarAlert, animated: true, completion: nil)
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }

}
