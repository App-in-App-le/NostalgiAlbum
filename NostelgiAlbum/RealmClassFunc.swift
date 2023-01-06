//
//  File.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/11/26.
//

import Foundation
import RealmSwift

class album : Object{
    // [index] : 몇 번째 앨범의 사진인지를 표시하기 위한 변수
    @objc dynamic var index : Int = 0
    /*
     [perAlbumIndex]
     1. 앨범 별로 현재 몇 번째에 있는 사진인지를 표시해야 edit 또는 delete시 realm이나 도큐먼트에서 정보를 가져올 수 있다.
     2. 만약 앨범 별로 카운트를 센다면 사진 저장 방식을 바꿔야 할 듯 함 (예를 들어, 첫 번째 앨범과 두 번째 앨범의 사진을 모두 1.jpg라고 저장하면 구분이 안되기 때문 -> 1_1, 2_1 이런 식으로 변경)
     3. 만약 중간에 있는 사진이 삭제된다면 DB에 존재하는 정보 뿐만 아니라 document에 있는 사진들의 이름 정보도 바꿔줘야 한다. (예를 들어, 첫 번째 앨범의 사진 개수가 5개 이고 1-3이 삭제되는 상황을
       가정해본다면 1_4 -> 1_3, 1_5 -> 1_4가 되어야 하기 때문!
    */
    @objc dynamic var perAlbumIndex : Int = 0
    @objc dynamic var ImageName : String = ""
    @objc dynamic var ImageText : String = ""
    @objc dynamic var AlbumTitle : String = ""
    
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
    @objc dynamic var id : Int = 0
    @objc dynamic var coverImageName : String = ""
    @objc dynamic var albumName : String = ""
    
    func setcoverImageName(_ db : String){
        coverImageName = db
    }
    
    func setalbumName(_ db : String){
        albumName = db
    }
    
    override static func primaryKey() -> String? {
          return "id"
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
    
    override static func primaryKey() -> String? {
          return "id"
    }
    
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

// albumScreenView Edit 기능이 생기면 삭제
func setAlbum(){
    let realm = try! Realm()
    let Add_album1 = album()
    let Add_album2 = album()
    let Add_album3 = album()
    let Add_album4 = album()

    func Realm_write(_ Add_album: album){
        do
        {
            try realm.write
            {
                realm.add(Add_album)
            }
        }
        catch{
            print("\(error)")
        }
    }

    Add_album1.setIndex(0)
    Add_album1.setImageName("지웅")
    Add_album1.setImageText("바닷가에서 폼 잡고 있는 지웅이")
    Realm_write(Add_album1)
    Add_album2.setIndex(0)
    Add_album2.setImageName("경범")
    Add_album2.setImageText("폼 잡고 있는 경범이 형")
    Realm_write(Add_album2)
    Add_album3.setIndex(0)
    Add_album3.setImageName("민구")
    Add_album3.setImageText("그냥 민구")
    Realm_write(Add_album3)
    Add_album4.setIndex(0)
    Add_album4.setImageName("철수")
    Add_album4.setImageText("늠름한 고양이 철수")
    Realm_write(Add_album4)
    
    
    print(Realm.Configuration.defaultConfiguration.fileURL!)
}

