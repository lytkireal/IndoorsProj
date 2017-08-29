//
//  Repo.swift
//  IndoorsProj
//
//  Created by macbook air on 27/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Repo {
  
  var id = 0
  var name = ""
  var description = ""
  var ownerLogin = ""
  var url = ""
  var forks = 0
  var watches = 0
  
//  required init(json: JSON) {
//    self.description = json["description"].string
//    self.id = json["id"].string
//    self.name = json["name"].string
//    self.ownerLogin = json["owner"]["login"].string
//    self.url = json["url"].string
//  }
  
  class func getMyRepos(completionHandler: @escaping (Array<Any>?, Any?) -> Void) {
    let path = "https://api.github.com/user/repos"
    
    if let head = GitHubAPIManager.sharedInstance.OAuthToken {
      print (head)
      
      let headers: HTTPHeaders = [
      "Authorization": "token \(GitHubAPIManager.sharedInstance.OAuthToken!)"
      ]
      print("getMyRepos, request")

      GitHubAPIManager.sharedInstance.sessionManager.request(path, headers: headers).responseJSON { response in
          if let anError = response.result.error {
            completionHandler(nil, anError)
            print(anError)
            return
          }
          
          if let receivedResults = response.result.value as? Array<Any>{
            print(receivedResults)
            completionHandler(receivedResults, nil)
          }
      }
    }
    
  }
  
}






