//
//  HomeScreenViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/06.
//

import UIKit

protocol SendDataDelegate: AnyObject{
    func send(data : String)
}

class HomeScreenViewController: UIViewController {
    
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 3
    }
    
    // 셀을 어떻게 표현할 것인지 (Presentation)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 만들어 놓은 ReusableCell 중에 사용할 셀을 고르는 부분
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        
        cell.callback1={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.pageNum = 0
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
        cell.callback2={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.pageNum = 0
            self.navigationController?.pushViewController(pushVC, animated: true)
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

