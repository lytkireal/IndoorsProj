//
//  SignInViewController.swift
//  IndoorsProj
//
//  Created by macbook air on 29/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, ReposViewControllerDelegate {

  var repos: [Repo] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if GitHubAPIManager.sharedInstance.OAuthToken != nil {
      if (!UserDefaults.standard.bool(forKey: "loadingOAuthToken")) {
        loadInitialData()
      }
    }
  }
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Implementation of ReposViewControllerDelegate methods ***
  //-----------------------------------------------------------------------------------------------
  //
  // - sign out
  
  func tableViewControllerSignOut(_ controller: ReposViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  //-----------------------------------------------------------------------------------------------
  
  @IBAction func signInStart() {
    print("SIGN IN tapped")
    //UserDefaults.standard.set(false, forKey: "loadingOAuthToken")
    //GitHubAPIManager.sharedInstance.OAuthToken = nil
    //print(UserDefaults.standard.bool(forKey: "loadingOAuthToken"))
    
    if (!UserDefaults.standard.bool(forKey: "loadingOAuthToken")) {
      loadInitialData()
    }
  }
  
  
  func loadInitialData() {
    print("in loadInitialData()")
    
    // *** if our GitHubAPIManager doesn't have oauth token ***    
    if (!GitHubAPIManager.sharedInstance.hasOAuthToken()) {
      
      GitHubAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
        (error) -> Void in
        
        if let receivedError = error {
          print(receivedError)
          
        } else {
          print("*** there is NOT oauth token ***")
          self.fetchMyRepos()
        }
      }
      
      // *** startOAuth2Login() ***
      GitHubAPIManager.sharedInstance.startOAuth2Login()
    
    // *** if our GitHubAPIManager have oauth token ***
    } else {
      print("*** there IS oauth token ***")
      fetchMyRepos()
    }
  }
  
  func fetchMyRepos() {
    
    Repo.getMyRepos(completionHandler: { (fetchedRepos, error) in
      
      if let receivedError = error {
        print(receivedError)
      } else {
        print("fetchedRepos")
        print(fetchedRepos!)
        
        let repoArr = fetchedRepos! as Array
        //print(self.parse(reposArray: repoArr))
        
        DispatchQueue.main.async {
          self.performSegue(withIdentifier: "Repos", sender: nil)
        }
        
        self.repos = self.parse(reposArray: repoArr)
        
        print("*******************************************************************************")
        print(self.repos)
        print("*******************************************************************************")
        

        
      }
      
    })
  }
  
  //-----------------------------------------------------------------------------------------------
  // Array parser
  func parse(reposArray: Array<Any>) -> [Repo] {
    print("*** parse dictionary ***")
    print(reposArray)
    
    var repos: [Repo] = []
    
    for repo in reposArray {
      print(repo)
      let eachRepo = repo as! NSDictionary
      print(eachRepo.allKeys)
      
      var repoItem: Repo!
      repoItem = self.parse(app: eachRepo as! [String : Any])
      
      if let result = repoItem {
        repos.append(result)
        print("ProductItem name is '\(result.name)'")
      }
      
    }
    return repos
  }
  
  //-----------------------------------------------------------------------------------------------
  // resultDict parser
  func parse(app dictionary: [String: Any]) -> Repo {
    let repoItem = Repo()
    
    repoItem.id = dictionary["id"] as! Int
    repoItem.name = dictionary["name"] as! String
    let owner = dictionary["owner"] as! [String: Any]
    repoItem.ownerLogin = owner["login"] as! String
    repoItem.url = dictionary["url"] as! String
    repoItem.forks = dictionary["forks"] as! Int
    repoItem.watches = dictionary["watchers_count"] as! Int
    
    
    return repoItem
  }
  //-----------------------------------------------------------------------------------------------
  
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Prepare-for-segue ***
  //-----------------------------------------------------------------------------------------------
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "Repos" {
      
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! ReposViewController
      
      controller.delegate = self
      
      controller.listOfRepos = repos
    
    }
    
  }
  //-----------------------------------------------------------------------------------------------
}




















