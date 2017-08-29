//
//  SingleRepoViewController.swift
//  IndoorsProj
//
//  Created by macbook air on 29/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//



import UIKit

protocol SingleRepoViewControllerDelegate {
  func singleRepoViewControllerDidCancel(_ controller: SingleRepoViewController)
}

class SingleRepoViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ownerLabel: UILabel!
  @IBOutlet weak var forksLabel: UILabel!
  @IBOutlet weak var watchesLabel: UILabel!
  
  var repo: Repo?
  
  weak var delegate: ReposViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inputData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  @IBAction func backToRepos() {
    delegate?.singleRepoViewControllerDidCancel(self)
  }

  
  func inputData() {
    
    nameLabel.text = repo!.name
    ownerLabel.text = "Owner \(repo!.ownerLogin)"
    forksLabel.text = "Forks: \(repo!.forks)"
    watchesLabel.text = "Watches: \(repo!.watches)"
    
  }
}
