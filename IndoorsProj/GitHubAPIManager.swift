//
//  File.swift
//  IndoorsProj
//
//  Created by macbook air on 27/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class GitHubAPIManager {
  
  static let sharedInstance = GitHubAPIManager()
  
  var sessionManager: SessionManager
  
  var OAuthTokenCompletionHandler:((NSError?) -> Void)?
  
  var clientID: String = "f2ad09a76e432f4f1f3b"
  var clientSecret: String = "fbb5f38183431afd3ea5cf5f0cab84370c4f8118"
  
  init () {
    var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    defaultHeaders["Accept"] = "application/vnd.github.v3+json"
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = defaultHeaders
    sessionManager = Alamofire.SessionManager(configuration: configuration)
  }
  
  var OAuthToken: String? {
    set {
      
      if let valueToSave = newValue {
        do {
          try Locksmith.updateData(data: ["token": valueToSave], forUserAccount: "github")
        } catch {
          print (error)
          do {
            try Locksmith.deleteDataForUserAccount(userAccount: "github")
          } catch {
            print(error)
          }
        }
      
      } else {
        do {
          try Locksmith.deleteDataForUserAccount(userAccount: "github")
        } catch {
          print(error)
        }
      }
      
    } get {
      // TODO: implement
      // try to load from keychain
      let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
      if let token =  dictionary?["token"] as? String {
        return token
      }
      return nil
    }
  }
  
  
  //---------------------------------------------------------------------------------------------------------------
  //                              *** check that we have or not OAuthToken ***
  //---------------------------------------------------------------------------------------------------------------
  func hasOAuthToken() -> Bool {
    if let token = self.OAuthToken {
      return !token.isEmpty
    }
    return false
  }
  //---------------------------------------------------------------------------------------------------------------
  
  
//---------------------------------------------------------------------------------------------------------------
//                              *** Send User to GitHub ***
//---------------------------------------------------------------------------------------------------------------
//
  // MARK: - OAuth flow
  func startOAuth2Login() {
    let authPath:String = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=repo&state=TEST_STATE"
    if let authURL:NSURL = NSURL(string: authPath)
    {
      UserDefaults.standard.setValue(true, forKey: "loadingOAuthToken")
      
      // *** open github sign in page ***
      UIApplication.shared.open(authURL as URL)
    }
  }
//---------------------------------------------------------------------------------------------------------------
  
  
//---------------------------------------------------------------------------------------------------------------
//                              *** Swap the received Code for a Token ***
//---------------------------------------------------------------------------------------------------------------
//
  
  func processOAuthStep1Response(url: URL) {
    //print(UserDefaults.standard.value(forKey: "loadingOAuthToken")!)
    print("processOAuthStep1Response() results:")
    print(url)
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    
    var code:String?
    if let queryItems = components?.queryItems {
      for queryItem in queryItems {
        if (queryItem.name.lowercased() == "code") {
          code = queryItem.value
          break
        }
      }
    }
    //---------------------------------------------------------------------------------------------------------------
    //                              *** received code is NOT EMPTY ***
    //---------------------------------------------------------------------------------------------------------------
    if let receivedCode = code {
      let getTokenPath:String = "https://github.com/login/oauth/access_token"
      let tokenParams = ["client_id": clientID, "client_secret": clientSecret, "code": receivedCode]
      
      Alamofire.request(getTokenPath, method: .post, parameters: tokenParams)
        .responseString { response in
          // TODO: handle response to extract OAuth token
          
          // *** there is error in response ***
          if let anError = response.error
          {
            print(anError)
            
            if let completionHandler = self.OAuthTokenCompletionHandler
            {
              let nOAuthError = NSError(domain: Alamofire.NSURLErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
              completionHandler(nOAuthError)
            }
            UserDefaults.standard.setValue(false, forKey: "loadingOAuthToken")
        
            return
          }
          
          // *** SUCCESSFUL response ***
          if let receivedResults = response.result.value {
            let resultParams:Array<String> = receivedResults.components(separatedBy: "&")
            for param in resultParams {
              
              let resultsSplit = param.components(separatedBy: "=")
              if (resultsSplit.count == 2) {
                let key = resultsSplit[0].lowercased() // access_token, scope, token_type
                let value = resultsSplit[1]
                
                switch key {
                case "access_token":
                  print("access_token")
                  self.OAuthToken = value
                case "scope":
                  // TODO: verify scope
                  print("SET SCOPE")
                case "token_type":
                  // TODO: verify is bearer
                  print("CHECK IF BEARER")
                default:
                  print("got more than I expected from the OAuth token exchange")
                  print(key)
                  print(value)
                  
                }
              }
            }
          }
          
          UserDefaults.standard.setValue(false, forKey: "loadingOAuthToken")
          
          if self.hasOAuthToken() {
            if let completionHandler = self.OAuthTokenCompletionHandler {
              completionHandler(nil)
            }
          } else {
            if let completionHandler = self.OAuthTokenCompletionHandler {
              let noOAuthError = NSError(domain: Alamofire.NSURLErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
              completionHandler(noOAuthError)
            }
          }
      }
      
    //---------------------------------------------------------------------------------------------------------------
    //                              *** received code is EMPTY ***
    //---------------------------------------------------------------------------------------------------------------
    } else {
      // no code in URL that we launched with
      UserDefaults.standard.setValue(false, forKey: "loadingOAuthToken")
    }
  }
//---------------------------------------------------------------------------------------------------------------

}

















//---------------------------------------------------------------------------------------------------------------
//                              ***  ***
//---------------------------------------------------------------------------------------------------------------
//

//---------------------------------------------------------------------------------------------------------------
