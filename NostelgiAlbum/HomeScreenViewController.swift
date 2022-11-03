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
    // UICollectionView가 인지하도록 해줘야 하는 요소
    // Data         : 어떤 데이터를 사용할지 정의
    // Presentation : 셀을 어떻게 표현할 것인지를 정의
    // Layout       : 셀을 어떻게 배치할 것인지를 정의
    
    // dataSource, delegate : protocol 방식으로 작동
    // protocol     : 작동하기 위해 일정의 약속이나 제약을 충족할 시 사용할 수 있도록 설정해놓은 코드
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
        // 셀을 3개로 구성한다는 의미
        // 보통은 동적으로 구성하기 위해 데이터의 개수로 정의한다.
        return 3
    }
    
    // 셀을 어떻게 표현할 것인지 (Presentation)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 만들어 놓은 ReusableCell 중에 사용할 셀을 고르는 부분
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        
        cell.callback1={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.data = "hello!"
            self.navigationController?.pushViewController(pushVC, animated: true)
            print("button pressed",indexPath, "firstButton")
        }
        cell.callback2={
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            pushVC.data = "Good bye!"
            self.navigationController?.pushViewController(pushVC, animated: true)
            print("button pressed",indexPath, "secondButton")
        }
        return cell
    }
}



extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width == collectionView's width
        // height == 190
        return CGSize(width: collectionView.bounds.width, height: 190)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

