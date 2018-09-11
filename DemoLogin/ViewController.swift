//
//  ViewController.swift
//  DemoLogin
//
//  Created by dohien on 11/09/2018.
//  Copyright © 2018 dohien. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if (FBSDKAccessToken.current()) != nil {
            facebooklogin()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("completed login")
        facebooklogin()
        fetchUserData()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
        // Do any additional setup after loading the view, typically from a nib.
   
//
//        self.facebooklogin()
//        fetchUserData()
func facebooklogin()
{
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], handler: { (result, error) -> Void in

        print("\n\n result: \(String(describing: result))")
        print("\n\n Error: \(String(describing: error))")

        if (error == nil)
        {
            let fbloginresult : FBSDKLoginManagerLoginResult = result!

            if(fbloginresult.isCancelled) {
                //Show Cancel alert
            } else if(fbloginresult.grantedPermissions.contains("email")) {
                self.returnUserData()

                //fbLoginManager.logOut()
            }
        }
    })
}

func returnUserData()
{
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
        if ((error) != nil)
        {
            // Process error
            print("\n\n Error: \(String(describing: error))")
        }
        else
        {
            let resultDic = result as! NSDictionary
            print("\n\n  fetched user: \(String(describing: result))")
            if (resultDic.value(forKey:"name") != nil)
            {
                let userName = resultDic.value(forKey:"name")! as! String as NSString?
                print("\n User Name is: \(String(describing: userName))")
            }

            if (resultDic.value(forKey:"email") != nil)
            {
                let userEmail = resultDic.value(forKey:"email")! as! String as NSString?
                print("\n User Email is: \(String(describing: userEmail))")
            }
        }
    })
    }
    private func fetchUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        graphRequest?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error",error!.localizedDescription)
            }
            else{
                print(result!)
                let field = result! as? [String:Any]
                self.nameLabel.text = field!["name"] as? String
                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    let url = URL(string: imageURL)
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.photoImage.image = image
                }
            }
        })
    }
    
}

