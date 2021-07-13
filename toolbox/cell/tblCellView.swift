//
//  tblCellView.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import Foundation
import UIKit
class TblCell: UITableViewCell {
    var type: String = ""
    var dataRow: [Item] = []
    @IBOutlet weak var lblCarrouselTitle: UILabel!
    @IBOutlet weak var colection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellWith(row: [Item], type: String) {
        self.colection.delegate = self
        self.colection.dataSource = self
        self.dataRow = row
        self.type = type
        self.colection.reloadData()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 133, height: type == "thumb" ? 133 : 235)
        layout.scrollDirection = .horizontal
        colection.delegate = self
        colection.dataSource = self
        self.colection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        contentView.isUserInteractionEnabled = false
   }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
}


extension TblCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataRow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionImages",
                    for: indexPath
                ) as! CollectionImages
        let itemSelected = self.dataRow[indexPath.row]
        cell.name.text = itemSelected.title
        let urlSecure = itemSelected.imageURL.replacingOccurrences(of: "http", with: "https")
        let url = URL(string: "\(urlSecure).jpg")
        cell.img.load(url: url!)
//        if(data != nil){
//
//        } else {
//            cell.img.image = type == "thumb" ? UIImage(named: "noimageThumb") : UIImage(named: "noImagePoster")
//        }
        return cell
    }
}
