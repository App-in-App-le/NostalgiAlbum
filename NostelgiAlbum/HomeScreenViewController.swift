import UIKit
import RealmSwift


class HomeScreenViewController: UIViewController {
    let realm = try! Realm()
    
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("####path",Realm.Configuration.defaultConfiguration.fileURL!)
//         Realm DB안에 있는 정보를 모두 제거
        try! realm.write{
            realm.deleteAll()
        }
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
    
    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        let editCoverAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "앨범 삭제", style: .default){
            (action) in self.deleteAlbumCover(gesture.albumIndex, gesture.albumName)
        }
        // 앨범 삭제 버튼 text 색 Red로 변경
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        editCoverAlert.addAction(delete)

        present(editCoverAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            editCoverAlert.view.superview?.isUserInteractionEnabled = true
            editCoverAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    class customLongPressGesture : UILongPressGestureRecognizer{
        var albumIndex : Int!
        var albumName : String!
    }
    
    private func deleteAlbumCover(_ albumIndex : Int, _ albumName : String){
        // realmDB 에서 해당 내용을 삭제하는 코드 작성
        // Album의 개수
        let albumCoverNum = realm.objects(albumCover.self).count
        // albumCover
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(albumIndex)")
        // album
        let albumData = realm.objects(album.self).filter("index = \(albumIndex)")
        // albumsinfo
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(albumIndex)")
        try! realm.write{
            realm.delete(albumCoverData)
            realm.delete(albumData)
            realm.delete(albumsInfoData)
        }
        
        // document 에서 해당 내용을 삭제하는 코드를 작성 - FileManager 이용
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}

        let albumDirectory = documentDirectory.appendingPathComponent(albumName)

        if FileManager.default.fileExists(atPath: albumDirectory.path) {
            do {
                try FileManager.default.removeItem(at: albumDirectory)
            } catch {
                print("폴더를 삭제하지 못했습니다.")
            }
        }
        
        // DB의 index값들 당겨오기
        if albumCoverNum != albumIndex{
            for index in (albumIndex + 1)...albumCoverNum{
                // albumCover
                let albumCoverData = realm.objects(albumCover.self).filter("id = \(index)")
                // albumsinfo
                let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(index)")
                // album
                let albumData = realm.objects(album.self).filter("index = \(index)")
                // index 처리
                try! realm.write{
                    albumCoverData.first!.id -= 1
                    albumsInfoData.first!.id -= 1
                    if albumData.count != 0{
                        for data in albumData{
                            data.index -= 1
                        }
                    }
                    realm.add(albumCoverData)
                    realm.add(albumsInfoData)
                    realm.add(albumData)
                }
            }
        }
        collectionView.reloadData()
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}

// DataSource, Delegate에 대한 extension을 정의
extension HomeScreenViewController: UICollectionViewDataSource{
    // Collection View 안에 셀을 몇개로 구성할 것인지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 책장을 고정해두기 위해 row를 3으로 고정
        return 3
    }
    
    // 셀을 어떻게 표현할 것인지 (Presentation)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 만들어 놓은 ReusableCell 중에 사용할 셀을 고르는 부분
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        // 초기 이미지 설정
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        // 초기 제스처 설정
        cell.firstButton.gestureRecognizers = nil
        cell.secondButton.gestureRecognizers = nil
        
        let cover_num = realm.objects(albumCover.self).count + 1
        
        if (indexPath.row + 1) * 2 <= cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            let firstbuttonInfo : albumCover?
            let secondbuttonInfo : albumCover?
            firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first
            secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first
            if firstbuttonInfo != nil{
                image = UIImage(named: firstbuttonInfo!.coverImageName)
                cell.firstButton.setImage(image, for: .normal)
                // 제스쳐 설정 (LongPressGesture)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 1
                LongPressGestureRecognizer.albumName = firstbuttonInfo!.albumName
                cell.firstButton.addGestureRecognizer(LongPressGestureRecognizer)
            }
            if secondbuttonInfo != nil{
                image = UIImage(named: secondbuttonInfo!.coverImageName)
                cell.secondButton.setImage(image, for: .normal)
                // 제스쳐 설정 (LongPressGesture)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 2
                LongPressGestureRecognizer.albumName = secondbuttonInfo!.albumName
                cell.secondButton.addGestureRecognizer(LongPressGestureRecognizer)
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
                pushVC.coverIndex = indexPath.row * 2 + 1
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
                pushVC.coverIndex = indexPath.row * 2 + 2
                self.navigationController?.pushViewController(pushVC, animated: false)
            }
        }
        return cell
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
