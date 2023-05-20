import UIKit

extension AlbumPicViewController {
    func setShadow() {
        picImageShadowView.layer.shadowOffset = CGSize(width: 6, height: 6)
        picImageShadowView.layer.shadowOpacity = 0.15
        picImageShadowView.layer.shadowRadius = 4

        picImageShadowView.layer.shadowColor = UIColor.black.cgColor
        picImageShadowView.layer.masksToBounds = false
        picImageShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        picNameShadowView.layer.shadowOffset = CGSize(width: 6, height: 6)
        picNameShadowView.layer.shadowOpacity = 0.15
        picNameShadowView.layer.shadowRadius = 4

        picNameShadowView.layer.shadowColor = UIColor.black.cgColor
        picNameShadowView.layer.masksToBounds = false
        picNameShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        picTextShadowView.layer.shadowOffset = CGSize(width: 6, height: 6)
        picTextShadowView.layer.shadowOpacity = 0.15
        picTextShadowView.layer.shadowRadius = 4

        picTextShadowView.layer.shadowColor = UIColor.black.cgColor
        picTextShadowView.layer.masksToBounds = false
        picTextShadowView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension HomeScreenCollectionViewCell {
    func setShadow() {
        firstButtonShadowView.layer.shadowOffset = CGSize(width: 8, height: 8)
        firstButtonShadowView.layer.shadowOpacity = 0.25
        firstButtonShadowView.layer.shadowRadius = 4
        
        firstButtonShadowView.layer.shadowColor = UIColor.black.cgColor
        firstButtonShadowView.layer.masksToBounds = false
        
        secondButtonShadowView.layer.shadowOffset = CGSize(width: 8, height: 8)
        secondButtonShadowView.layer.shadowOpacity = 0.25
        secondButtonShadowView.layer.shadowRadius = 4
        
        secondButtonShadowView.layer.shadowColor = UIColor.black.cgColor
        secondButtonShadowView.layer.masksToBounds = false
    }
}
