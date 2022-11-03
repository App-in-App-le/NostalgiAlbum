//
//  AlbumScreenViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/31.
//

import UIKit

class AlbumScreenViewController: UIViewController {

    var data : String = ""
    var image : UIImage?
    
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
        print(data)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

// DataSource, Delegate에 대한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumScreenCollectionViewCell", for: indexPath) as! AlbumScreenCollectionViewCell
        cell.configure(data);
        return cell
    }
}

// layout에 관한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 315)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
