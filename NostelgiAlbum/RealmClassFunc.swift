//
//  File.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/11/26.
//

import Foundation
import RealmSwift

class album : Object{
    @objc dynamic var id : Int = 0
    @objc dynamic var index : Int = 0
    @objc dynamic var ImageName : String = ""
    @objc dynamic var ImageText : String = ""
    
    func setIndex(_ db : Int){
        index = db
    }
    func setImageName(_ db : String){
        ImageName = db
    }
    func setImageText(_ db : String){
        ImageText = db
    }
    
    override static func primaryKey() -> String? {
          return "id"
    }
    
    func incrementIndex(){
        let realm = try! Realm()
        id = (realm.objects(album.self).max(ofProperty: "id") as Int? ?? 0) + 1
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

func setAlbumCover(){
    let realm = try! Realm()
    let Add_albumCover1 = albumCover()
    let Add_albumCover2 = albumCover()
    Add_albumCover1.incrementIndex()
    Add_albumCover1.setalbumName("가족 앨범")
    Add_albumCover1.setcoverImageName("family.png")
    func Realm_write(_ cover : albumCover){
        do
        {
            try realm.write
            {
                realm.add(cover)
            }
        }
        catch{
            print("\(error)")
        }
    }
    Realm_write(Add_albumCover1)
    Add_albumCover2.incrementIndex()
    Add_albumCover2.setalbumName("우정 앨범")
    Add_albumCover2.setcoverImageName("friend.png")
    Realm_write(Add_albumCover2)
    
    print(Realm.Configuration.defaultConfiguration.fileURL!)
}

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

    Add_album1.incrementIndex()
    Add_album1.setIndex(0)
    Add_album1.setImageName("지웅")
    Add_album1.setImageText("바닷가에서 폼 잡고 있는 지웅이")
    Realm_write(Add_album1)
    Add_album2.incrementIndex()
    Add_album2.setIndex(0)
    Add_album2.setImageName("경범")
    Add_album2.setImageText("폼 잡고 있는 경범이 형")
    Realm_write(Add_album2)
    Add_album3.incrementIndex()
    Add_album3.setIndex(0)
    Add_album3.setImageName("민구")
    Add_album3.setImageText("그냥 민구")
    Realm_write(Add_album3)
    Add_album4.incrementIndex()
    Add_album4.setIndex(0)
    Add_album4.setImageName("철수")
    Add_album4.setImageText("늠름한 고양이 철수")
    Realm_write(Add_album4)
    
    
    print(Realm.Configuration.defaultConfiguration.fileURL!)
}

