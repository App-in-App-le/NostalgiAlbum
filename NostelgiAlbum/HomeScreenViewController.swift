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
    
    var order:Int = 0
    var row:Int = 0
    var image: UIImage?
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setAlbum()
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
        return self.row + 1
    }
    
    // 셀을 어떻게 표현할 것인지 (Presentation)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 만들어 놓은 ReusableCell 중에 사용할 셀을 고르는 부분
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        
        let firstbuttonInfo : albumCover?
        let secondbuttonInfo : albumCover?
        firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first
        secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first
        
        if firstbuttonInfo != nil{
            image = UIImage(named: firstbuttonInfo!.coverImageName)
            cell.firstButton.setImage(image, for: .normal)
            cell.firstButton.setTitle(firstbuttonInfo!.albumName, for: .normal)
        }
        if secondbuttonInfo != nil{
            image = UIImage(named: secondbuttonInfo!.coverImageName)
            cell.secondButton.setImage(image, for: .normal)
            cell.secondButton.setTitle(secondbuttonInfo!.albumName, for: .normal)
        }
        
        
        // 1번째 인자 빼고 전부 hidden state
        if indexPath.row != 0 || self.order != 0{
            cell.firstButton.isHidden = true
            cell.secondButton.isHidden = true
        }
        else{
            cell.secondButton.isHidden = true
        }

        // 하나씩 해제 되는 코드
        if indexPath.row < self.row{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
        }
        else if indexPath.row == self.row{
            if self.order == 0{
                cell.firstButton.isHidden = false
            }
            else {
                cell.firstButton.isHidden = false
                cell.secondButton.isHidden = false
            }
        }
        
        cell.callback1={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.pageNum = 0
            self.order = self.order + 1
            self.collectionView.reloadData()
            self.navigationController?.pushViewController(pushVC, animated: false)
        }
        
        cell.callback2={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.pageNum = 0
            self.order = self.order - 1
            self.row = self.row + 1
            self.collectionView.reloadData()
            self.navigationController?.pushViewController(pushVC, animated: false)
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

