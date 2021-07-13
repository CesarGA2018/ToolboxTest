//
//  ListViewController.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import UIKit
import JWTDecode

class ListViewController: UIViewController {
    var carrousell: [Carrousell] = []
    var carrousellItems: [Item] = []
    var carrousellTypeSel: String = ""
    let manager = ManagerPreferences.shared
    let api = CoreApi()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tblCarrousell: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCarrousell.separatorStyle = UITableViewCell.SeparatorStyle.none
        refreshControl.attributedTitle = NSAttributedString(string: "Actualizar")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblCarrousell.addSubview(refreshControl) // not required when using UITableViewController
        self.loadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       loadData()
    }
    
    func loadData(){
        let dateDbl = self.manager.readingeExpirationDate()
        if(dateDbl != 0){
            let date = Date(timeIntervalSince1970: dateDbl)
            let dt = Date()
            if(dt < date){
                self.api.listenerGetCarrousel = self
                self.api.getCarrousell(type: "Bearer", token: self.manager.readingToken())
            } else {
                self.api.listenerGetToken = self
                self.api.getToken()
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.manager.writeToken("")
        self.manager.writeExpirationDate(0)
        self.manager.writeIsLogin(false)
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}

extension ListViewController: ListenerGetToken {
    func successGetToken(_ response: Auth) {
        self.manager.writeToken(response.token)
        do {
            let jwt = try decode(jwt: response.token)
            self.manager.writeExpirationDate(jwt.body["iat"] as! Double)
            print("Proxima Expiración", self.manager.readingeExpirationDate())
            
            DispatchQueue.main.async {
                self.loadData()
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

extension ListViewController: ListenerGetCarrousell {
    func successGetCarrousell(_ response: [Carrousell]) {
        self.carrousell = response
        DispatchQueue.main.async {
            self.tblCarrousell.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func failureGetCarrousell(_ loginError: String) {
        print(loginError)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carrousell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carrousellSelected = self.carrousell[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: carrousellSelected.type == "thumb" ? "TblCell" : "TblCellPoster",
                    for: indexPath
                ) as! TblCell
        
       
        self.carrousellTypeSel = carrousellSelected.type
        cell.lblCarrouselTitle.text = carrousellSelected.title
        cell.updateCellWith(row: carrousellSelected.items, type: carrousellSelected.type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let carrousellSelected = self.carrousell[indexPath.row]
        return carrousellSelected.type == "thumb" ? 200.0 : 311.0;//Choose your custom row height
    }
}
