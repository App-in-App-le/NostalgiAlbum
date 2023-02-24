import UIKit
import RealmSwift

// - MARK: HomeScreenViewController + CollectionView
extension HomeScreenViewController: UICollectionViewDataSource{
    
    // - MARK: CollectionView :: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // - MARK: CollectionView :: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cell을 Reuseidenfier를 이용해 생성
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        
        // Cell의 프로퍼티들을 초기화 :: DataReload() 사용 시, cell에 reference로 연결된 객체들을 해제시키기 위함.
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.firstButton.gestureRecognizers = nil
        cell.secondButton.gestureRecognizers = nil
        
        // CollectionView에 표시되어야 하는 버튼의 개수를 Cover_num 변수에 저장 :: (총 앨범의 개수 + 1)
        let cover_num = realm.objects(albumCover.self).count + 1
        
        // 각 열별로 Case를 나누어 각 열에 존재하는 button들의 isHidden Option을 설정
        // FIRST CASE :: (cover_num / 2)개 까지의 열을 처리 -> cover_num이 홀수 개인 경우 따로 처리해줘야 함.
        if (indexPath.row + 1) * 2 <= cover_num {
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            
            // First Button :: 무조건 존재 함 -> Set button
            if let firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first {
                cell.firstButton.setImage(UIImage(named: firstbuttonInfo.coverImageName), for: .normal)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 1
                LongPressGestureRecognizer.albumName = firstbuttonInfo.albumName
                cell.firstButton.addGestureRecognizer(LongPressGestureRecognizer)
            } else {
                print("RealmDB Error occur!")
            }
            // Second Button :: case1. 존재하는 경우 -> Set button
            // Second Button :: case2. 존재하지 않는 경우 -> Doesn't Set button
            if let secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first {
                cell.secondButton.setImage(UIImage(named: secondbuttonInfo.coverImageName), for: .normal)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 2
                LongPressGestureRecognizer.albumName = secondbuttonInfo.albumName
                cell.secondButton.addGestureRecognizer(LongPressGestureRecognizer)
            }
        }
        // SECOND CASE :: cover_num이 홀수 개인 경우 마지막 빈 버튼에 대한 처리
        else if (indexPath.row + 1) * 2 - 1 == cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = true
        }
        // THIRD CASE :: 아직 생성되지 않은 앨범 버튼에 대한 처리
        else{
            cell.firstButton.isHidden = true
            cell.secondButton.isHidden = true
        }
        
        // 각 Cell의 firstButton / SecondButton Action을 지정
        // Callback1 :: First button Action
        cell.callback1 = {
            if cell.firstButton.imageView?.image == UIImage(systemName: "plus"){
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.collectionViewInHome = self.collectionView
                self.present(editVC, animated: false)
            }
            else {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as! AlbumScreenViewController
                pushVC.pageNum = 0
                pushVC.coverIndex = indexPath.row * 2 + 1
                self.navigationController?.pushViewController(pushVC, animated: false)
            }
        }
        // Callback2 :: Second button Action
        cell.callback2 = {
            if cell.secondButton.imageView?.image == UIImage(systemName: "plus"){
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.collectionViewInHome = self.collectionView
                self.present(editVC, animated: false)
            }
            else{
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as! AlbumScreenViewController
                pushVC.pageNum = 0
                pushVC.coverIndex = indexPath.row * 2 + 2
                self.navigationController?.pushViewController(pushVC, animated: false)
            }
        }
        return cell
    }
    
}

// - MARK: HomeScreenViewController의 UICollectionView Layout을 지정
extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    
    // - MARK: 각 Cell별로 width와 Height를 정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }
    
    // - MARK: 각 Cell 사이에 거리를 지정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
