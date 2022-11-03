//
//  AlbumModel.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/11/03.
//

import Foundation

struct AlbumModel {
    let pictureName: String
    let pictureLabel: String
}

extension AlbumModel {
    static let list: [AlbumModel] = [
        AlbumModel(pictureName: "지웅", pictureLabel: "바닷가에서 폼 잡고 있는 지웅이"),
        AlbumModel(pictureName: "경범", pictureLabel: "폼 잡고 있는 경범이 형"),
        AlbumModel(pictureName: "민구", pictureLabel: "그냥 민구"),
        AlbumModel(pictureName: "철수", pictureLabel: "귀여운듯한 고양이 철수"),
    ]
}
