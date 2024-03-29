import UIKit
import RealmSwift

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
        
        self.pictureLabel.font = UIFont(name: selected_font_Eng!, size: 15)
    }
}

extension AlbumEditViewController {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        self.saveButton.titleLabel?.font = UIFont(name: selected_font_Eng!, size: 13)
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

extension PageSearchViewController {
    func setFont() {
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
                
        let height = UIScreen.main.bounds.size.height
        switch height {
        case 667.0:
            self.fpTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)
            self.fpContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)
            self.spTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)
            self.spContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)
            
            self.fpTitle.font = UIFont(name: selected_font_Eng!, size: 12)
            self.fpContent.font = UIFont(name: selected_font_Eng!, size: 12)
            self.spTitle.font = UIFont(name: selected_font_Eng!, size: 12)
            self.spContent.font = UIFont(name: selected_font_Eng!, size: 12)

        case 736.0:
            self.fpTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
            self.fpContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
            self.spTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
            self.spContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
            
            self.fpTitle.font = UIFont(name: selected_font_Eng!, size: 13)
            self.fpContent.font = UIFont(name: selected_font_Eng!, size: 13)
            self.spTitle.font = UIFont(name: selected_font_Eng!, size: 13)
            self.spContent.font = UIFont(name: selected_font_Eng!, size: 13)

        case 812.0:
            self.fpTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 15)
            self.fpContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 15)
            self.spTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 15)
            self.spContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 15)
            
            self.fpTitle.font = UIFont(name: selected_font_Eng!, size: 14)
            self.fpContent.font = UIFont(name: selected_font_Eng!, size: 14)
            self.spTitle.font = UIFont(name: selected_font_Eng!, size: 14)
            self.spContent.font = UIFont(name: selected_font_Eng!, size: 14)

        case 896.0:
            self.fpTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 16)
            self.fpContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 16)
            self.spTitleText.font = UIFont(name: "PyeongChangPeace-Light", size: 16)
            self.spContentText.font = UIFont(name: "PyeongChangPeace-Light", size: 16)
            
            self.fpTitle.font = UIFont(name: selected_font_Eng!, size: 15)
            self.fpContent.font = UIFont(name: selected_font_Eng!, size: 15)
            self.spTitle.font = UIFont(name: selected_font_Eng!, size: 15)
            self.spContent.font = UIFont(name: selected_font_Eng!, size: 15)

        default:
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

extension ContentsCells {
    func setFont() {
        let realm = try! Realm()
        let albumInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
        let selected_font_Kor = albumInfo.font
        let selected_font_Eng = FontSet().font[selected_font_Kor]
        
        let height = UIScreen.main.bounds.size.height
        switch height {
        case 667.0:
            self.title.font = UIFont(name: selected_font_Eng!, size: 10)
            self.contents.font = UIFont(name: selected_font_Eng!, size: 10)
            self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 10)
            self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 10)
            
        case 736.0:
            self.title.font = UIFont(name: selected_font_Eng!, size: 11)
            self.contents.font = UIFont(name: selected_font_Eng!, size: 11)
            self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 11)
            self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 11)
        
        case 812.0:
            self.title.font = UIFont(name: selected_font_Eng!, size: 12)
            self.contents.font = UIFont(name: selected_font_Eng!, size: 12)
            self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 12)
            self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 12)
        
        case 896.0:
            self.title.font = UIFont(name: selected_font_Eng!, size: 13)
            self.contents.font = UIFont(name: selected_font_Eng!, size: 13)
            self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)
            self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 13)

        default:
            self.title.font = UIFont(name: selected_font_Eng!, size: 14)
            self.contents.font = UIFont(name: selected_font_Eng!, size: 14)
            self.titleText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
            self.contentsText.font = UIFont(name: "PyeongChangPeace-Light", size: 14)
        }
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
                messageText.addAttribute(.font, value: UIFont(name: font, size: 14)!, range: (message as NSString).range(of: message))
            } else {
                messageText.addAttribute(.font, value: UIFont(name: "EF_watermelonSalad", size: 14)!, range: (message as NSString).range(of: message))
            }
            self.setValue(messageText, forKey: "attributedMessage")
        }
    }
}
