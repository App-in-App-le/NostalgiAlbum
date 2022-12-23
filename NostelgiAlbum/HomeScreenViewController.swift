//
//  HomeScreenViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/06.
//

import UIKit
import RealmSwift


class HomeScreenViewController: UIViewController {
    let realm = try! Realm()
    
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    
    var image: UIImage?
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("####path",Realm.Configuration.defaultConfiguration.fileURL!)
        var start = 1
        let count = realm.objects(albumCover.self).count
        while start <= count{
            deleteImageFromDocumentDirectory(imageName: "\(start).png")
            start += 1
        }
        try! realm.write{
            realm.deleteAll()
        }
        setAlbum()
//        setAlbumCover()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// DataSource, Delegate에 대한 extension을 정의

extension HomeScreenViewController: UICollectionViewDataSource{
    // Collection View 안에 셀을 몇개로 구성할 것인지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cover_num = realm.objects(albumCover.self).count + 1
        // 앨범의 개수를 6개로 제한
        if cover_num == 7{
            return 3
        }
        return cover_num % 2 == 0 ? cover_num/2 : cover_num/2 + 1
    }
    
    // 셀을 어떻게 표현할 것인지 (Presentation)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 만들어 놓은 ReusableCell 중에 사용할 셀을 고르는 부분
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        // 초기 이미지 설정
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        let cover_num = realm.objects(albumCover.self).count + 1
        print("####\(cover_num)")
        if (indexPath.row + 1) * 2 <= cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            let firstbuttonInfo : albumCover?
            let secondbuttonInfo : albumCover?
            firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first
            secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first
            if firstbuttonInfo != nil{
                image = loadImageFromDocumentDirectory(imageName: firstbuttonInfo!.coverImageName)
                cell.firstButton.setImage(resizeingImage(image: self.image!, width: 120, height: 160), for: .normal)
            }
            if secondbuttonInfo != nil{
                image = loadImageFromDocumentDirectory(imageName: secondbuttonInfo!.coverImageName)
                cell.secondButton.setImage(resizeingImage(image: self.image!, width: 120, height: 160), for: .normal)
            }
        }
        else if (indexPath.row + 1) * 2 - 1 == cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = true
        }
        else{
            cell.firstButton.isHidden = true
            cell.secondButton.isHidden = true
        }
        
        cell.callback1={
            if cell.firstButton.imageView?.image == UIImage(systemName: "plus"){
                guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.collectionViewInHome = self.collectionView
                self.present(editVC, animated: false)
            }
            else{
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                pushVC.pageNum = 0
                pushVC.coverIndex = indexPath.row * 2
                self.navigationController?.pushViewController(pushVC, animated: false)
            }
        }
        
        cell.callback2={
            if cell.secondButton.imageView?.image == UIImage(systemName: "plus"){
                guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as? HomeEditViewController else{ return }
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.collectionViewInHome = self.collectionView
                self.present(editVC, animated: false)
            }
            else{
                guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                pushVC.pageNum = 0
                pushVC.coverIndex = indexPath.row * 2 + 1
                self.navigationController?.pushViewController(pushVC, animated: false)
            }
        }
        return cell
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 190)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
    // 1. 도큐먼트 폴더 경로가져오기
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let directoryPath = path.first {
        // 2. 이미지 URL 찾기
        let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
        // 3. UIImage로 불러오기
        let loadImage = UIImage(contentsOfFile: imageURL.path)
        return fixOrientation(image: loadImage!)
    }
    
    return nil
}

func deleteImageFromDocumentDirectory(imageName: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    
    let imageURL = documentDirectory.appendingPathComponent(imageName)
    
    if FileManager.default.fileExists(atPath: imageURL.path) {
        do {
            try FileManager.default.removeItem(at: imageURL)
            print("이미지 삭제 완료")
        } catch {
            print("이미지를 삭제하지 못했습니다.")
        }
    }
}

func resizeingImage(image: UIImage, width: Int, height: Int) -> UIImage? {
    let customImage = image
    let newImageRect = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContext(CGSize(width: width, height: height))
    customImage.draw(in: newImageRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    return newImage
}

func fixOrientation(image: UIImage) -> UIImage{
    if(image.imageOrientation == .up){
        return image
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    image.draw(in: rect)
    let normailizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return normailizedImage
}
