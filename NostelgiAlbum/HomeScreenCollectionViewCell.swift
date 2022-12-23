//
//  HomeScreenCollectionViewCell.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/06.
//

import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    var i : Int = 0
    //var chop : IndexPath?
    
    class var identifier: String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    var callback1 : (()->Void)?
    var callback2 : (()->Void)?
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var firstButtonSq: UILabel!
    @IBOutlet weak var secondButtonSq: UILabel!
    
    @IBOutlet weak var firstButtonTitle: UILabel!
    @IBOutlet weak var secondButtonTitle: UILabel!
    
    @IBAction func makeButton(_ sender: Any) {
        callback2?()
    }
    
    @IBAction func fmakeButton(_ sender: Any) {
        callback1?()
    }
}

