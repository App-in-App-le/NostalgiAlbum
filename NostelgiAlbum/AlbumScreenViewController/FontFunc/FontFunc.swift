import UIKit

// tableView 같은 경우 Delegate 안에서 Font를 정해야하는 부분이 있기 때문에 따로 함수를 만들지 않고 Delegate안에서 해결하는 방식으로 처리함
// -> SettingViewController, FontSettingViewController, InfoViewController

// AlbumViewController
extension AlbumScreenViewController {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(coverIndex)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        let titleLabel = self.navigationItem.titleView as! UILabel
        titleLabel.font = UIFont(name: selected_font_Eng!, size: 18)
        
        let pageNumButton = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        pageNumButton.titleLabel?.font = UIFont(name: selected_font_Eng!, size: 15)
    }
}

extension AlbumScreenCollectionViewCell {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(albumSVC.coverIndex)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.pictureLabel?.font = UIFont(name: selected_font_Eng!, size: 15)
    }
}

extension AlbumEditViewController {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.saveButton.titleLabel?.font = UIFont(name: selected_font_Eng!, size: 14)
        self.editName.font = UIFont(name: selected_font_Eng!, size: 14)
        self.editText.font = UIFont(name: selected_font_Eng!, size: 14)
    }
}

extension AlbumPicViewController {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.picName.font = UIFont(name: selected_font_Eng!, size: 14)
        self.picText.font = UIFont(name: selected_font_Eng!, size: 14)
    }
}

// Tool Bar View Controller
extension PageSearchViewController {
    
}

extension ContentsSearchViewController {
    
}
