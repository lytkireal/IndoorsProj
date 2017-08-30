//
//  RepoCommitsViewController.swift
//  IndoorsProj
//
//  Created by macbook air on 30/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

protocol RepoCommitsViewControllerDelegate {
  func repoCommitsViewControllerDidCancel(_ controller: RepoCommitsViewController)
}


class RepoCommitsViewController: UITableViewController {

  var commitsURL: String?
  
  var allCommits: [Commit] = []
  
  
  
  weak var delegate: ReposViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getRepoCommit()

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    return self.allCommits.count
  }

  override func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
    
    let hash = cell.viewWithTag(1001) as! UILabel
    let commit = cell.viewWithTag(1002) as! UILabel
    let author = cell.viewWithTag(1003) as! UILabel
    let date = cell.viewWithTag(1004) as! UILabel
    
    
    //thumbnail.image = images[indexPath.row]
    
    
    hash.text = "Hash: \(allCommits[indexPath.row].sha)"
    commit.text = "Commit: \(allCommits[indexPath.row].commit)"
    author.text = "Author: \(allCommits[indexPath.row].author)"
    date.text = "Date: \(allCommits[indexPath.row].date)"
    
    
    return cell
    
  }
  
  //-------------------------------------------------------------------------------------------------------------
  //                      *** get commit info ***
  //-------------------------------------------------------------------------------------------------------------
  //
  func getRepoCommit() {
    
    print("in getRepoCommit() ")
    if var path = self.commitsURL {
      
      path = path + "/commits"
      
      GitHubAPIManager.sharedInstance.sessionManager.request(path).responseJSON { response in
        print("in request() ")
        if let anError = response.result.error {
          print(anError)
          return
        }
        
        if let receivedResults = response.result.value as? NSArray{
          print("*** REPO COMMITS ***")
          print(receivedResults)
          self.allCommits = self.parse(commitsArray: receivedResults)
          self.tableView.reloadData()
        }
      }
    }
  }
  //-------------------------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  // Array parser
  func parse(commitsArray: NSArray) -> [Commit] {
    print("*** parse dictionary ***")
    //print(reposArray)
    
    var commits: [Commit] = []
    
    for commit in commitsArray {
      print(commit)
      var commitItem: Commit!
      commitItem = self.parse(app: commit as! [String : Any])
      commits.append(commitItem)
//    for repo in commit {
//      //print(repo)
//      let eachRepo = repo as! NSDictionary
//      //print(eachRepo.allKeys)
//      
//      var repoItem: Repo!
//      repoItem = self.parse(app: eachRepo as! [String : Any])
//      
//      if let result = repoItem {
//        repos.append(result)
//        print("Repo name is '\(result.name)'")
//      }
      
    }
    print(commits)
    return commits
    
  }
  
  //-----------------------------------------------------------------------------------------------
  // resultDict parser
  func parse(app dictionary: [String: Any]) -> Commit {
    let commitItem = Commit()
    
    commitItem.sha = dictionary["sha"] as! String
    if let commit = dictionary["commit"] as? [String: Any] {
      commitItem.commit = commit["message"] as! String
      
      if let author = commit["author"] as? [String: Any] {
        commitItem.author = author["name"] as! String
        commitItem.date = author["date"] as! String
      }
    }


    

    
    print("commitItem")
    return commitItem
  }
  //-----------------------------------------------------------------------------------------------
}
