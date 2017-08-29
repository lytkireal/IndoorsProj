//
//  ReposViewController.swift
//  IndoorsProj
//
//  Created by macbook air on 27/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

protocol ReposViewControllerDelegate: class {
  
  func tableViewControllerSignOut(_ controller: ReposViewController)
  
}

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SingleRepoViewControllerDelegate{
  
  @IBOutlet var tableView: UITableView!
  //var repos: [Repo]
  
  weak var delegate: SignInViewController?
  
  var listOfRepos: [Repo]
  
  required init?(coder aDecoder: NSCoder){
    
    listOfRepos = [Repo]()
    
    super.init(coder: aDecoder)
  }

  
  //-----------------------------------------------------------------------------------------------
  //                      *** Implementation of ReposViewControllerDelegate methods ***
  //-----------------------------------------------------------------------------------------------
  //
  // - sign out
  
  func singleRepoViewControllerDidCancel(_ controller: SingleRepoViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  //-----------------------------------------------------------------------------------------------
  
  //-----------------------------------------------------------------------------------------------
  //                      *** Prepare-for-segue ***
  //-----------------------------------------------------------------------------------------------
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SingleRepo" {
      
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! SingleRepoViewController
      
      controller.delegate = self
      
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.repo = listOfRepos[indexPath.row]
      }
    }
    
  }
  //-----------------------------------------------------------------------------------------------
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Table is here")
    
    print(listOfRepos.count)
    
    tableView.reloadData()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  //-------------------------------------------------------------------------------------------------------------
  //                      *** table view's cells ***
  //-------------------------------------------------------------------------------------------------------------
  //

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("cells count")
    print(self.listOfRepos.count)
    return self.listOfRepos.count
  }
  
  func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Repo", for: indexPath)
    
    let repoName = cell.viewWithTag(1001) as! UILabel
    //let id = cell.viewWithTag(1002) as! UILabel
    //let ownerLogin = cell.viewWithTag(1003) as! UILabel
    //let url = cell.viewWithTag(1004) as! UILabel
    
    
    //thumbnail.image = images[indexPath.row]
    
    
    repoName.text = listOfRepos[indexPath.row].name
    //id.text = "Id: \(listOfRepos[indexPath.row].id)"
    //ownerLogin.text = "Owner: \(listOfRepos[indexPath.row].ownerLogin)"
    //url.text = "Url: \(listOfRepos[indexPath.row].url)"
    
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  //-------------------------------------------------------------------------------------------------------------
  

}

