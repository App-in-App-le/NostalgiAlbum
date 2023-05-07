import UIKit
import RealmSwift

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
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.fpTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 17)
        self.fpContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 17)
        self.spTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 17)
        self.spContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 17)
        
        self.fpTitle.font = UIFont(name: selected_font_Eng!, size: 16)
        self.fpContent.font = UIFont(name: selected_font_Eng!, size: 16)
        self.spTitle.font = UIFont(name: selected_font_Eng!, size: 16)
        self.spContent.font = UIFont(name: selected_font_Eng!, size: 16)
    }
}

extension PageCell {
    func setFont() {
        let realm = try! Realm()
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        self.button.titleLabel?.font = UIFont(name: selected_font_Eng!, size: 18)

    }
}

extension ContentsSearchViewController {
    
}

extension ContentsCells {
    func setFont() {
        let realm = try! Realm()
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.title.font = UIFont(name: selected_font_Eng!, size: 14)
        self.contents.font = UIFont(name: selected_font_Eng!, size: 14)
        self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
        self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
    }
}

extension UIAlertController {
    func setFont(font: String?, title: String?, message: String?) {
        // title string이 존재하는 경우
        if let title = title {
            let titleText = NSMutableAttributedString(string: title)
            if let font = font {
                titleText.addAttribute(.font, value: UIFont(name: font, size: 18)!, range: (title as NSString).range(of: title))
            } else {
                titleText.addAttribute(.font, value: UIFont(name: "EF_watermelonSalad", size: 18)!, range: (title as NSString).range(of: title))
            }
            self.setValue(titleText, forKey: "attributedTitle")
        }
        
        // message string이 존재하는 경우
        if let message = message {
            let messageText = NSMutableAttributedString(string: message)
            if let font = font {
                messageText.addAttribute(.font, value: UIFont(name: font, size: 13)!, range: (message as NSString).range(of: message))
            } else {
                messageText.addAttribute(.font, value: UIFont(name: "EF_watermelonSalad", size: 13)!, range: (message as NSString).range(of: message))
            }
            self.setValue(messageText, forKey: "attributedMessage")
        }
    }
}
