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
    var image: UIImage?{
        return UIImage(named: "album.png")
    }
    
    @IBAction func makeButton(_ sender: Any) {
        secondButton.setImage(image, for: UIControl.State.normal)
        secondButton.setTitle("", for: UIControl.State.normal)
        callback2?()
    }
    
    @IBAction func fmakeButton(_ sender: Any) {
        firstButton.setImage(image, for:    UIControl.State.normal)
        firstButton.setTitle("", for: UIControl.State.normal)
        callback1?()
    }
}

