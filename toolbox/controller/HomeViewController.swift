//
//  HomeViewController.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import UIKit
import JWTDecode

class HomeViewController: UIViewController {
    let manager = ManagerPreferences.shared
    let api = CoreApi()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(manager.readingeIsLogin()){
            self.goList()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        self.api.listenerGetToken = self
        self.api.getToken()
    }
    
    func goList() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: ListenerGetToken {
    func successGetToken(_ response: Auth) {
        self.manager.writeToken(response.token)
        do {
            let jwt = try decode(jwt: response.token)
            self.manager.writeExpirationDate(jwt.body["iat"] as! Double)
            print("Proxima Expiración", self.manager.readingeExpirationDate())
            self.manager.writeIsLogin(true)
            DispatchQueue.main.async {
                self.goList()
            }
        } catch let j{
            //handle error
            print(j)
        }
    }
    
    func failureGetToken(_ loginError: String) {
        print(loginError)
    }
}

