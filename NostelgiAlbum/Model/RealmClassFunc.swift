import Foundation
import RealmSwift

class album : Object{
    @objc dynamic var index: Int = 0
    @objc dynamic var perAlbumIndex: Int = 0
    @objc dynamic var ImageName: String = ""
    @objc dynamic var ImageText: String = ""
    @objc dynamic var AlbumTitle: String = ""
    
    func setPerAlbumIndex(_ db : Int){
        perAlbumIndex = db
    }
    
    func setIndex(_ db : Int){
        index = db
    }
    
    func setImageName(_ db : String){
        ImageName = db
    }
    
    func setImageText(_ db : String){
        ImageText = db
    }
    
    func setAlbumTitle(_ db : String){
        AlbumTitle = db
    }
}

class albumCover : Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var coverImageName: String = ""
    @objc dynamic var albumName: String = ""
    @objc dynamic var isCustomCover: Bool = false
    
    func setcoverImageName(_ db : String){
        coverImageName = db
    }
    
    func setalbumName(_ db : String){
        albumName = db
    }
    
    func incrementIndex(){
        let realm = try! Realm()
        id = (realm.objects(albumCover.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

class albumsInfo : Object{
    @objc dynamic var id : Int = 0
    @objc dynamic var numberOfPictures : Int = 0
    @objc dynamic var dateOfCreation : String = ""
    
    func setNumberOfPictures(_ num: Int){
        let realm = try! Realm()
        numberOfPictures = realm.objects(album.self).filter("index = \(num)").count
        print("num : ",numberOfPictures)
    }
    
    func setDateOfCreation(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateOfCreation = formatter.string(from:Date())
    }
    
    func incrementIndex(){
        let realm = try! Realm()
        id = (realm.objects(albumsInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

