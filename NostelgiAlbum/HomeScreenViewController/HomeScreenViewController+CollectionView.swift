import UIKit
import RealmSwift

extension HomeScreenViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue Reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        // Initialize Buttons' properties
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.firstButton.gestureRecognizers = nil
        cell.secondButton.gestureRecognizers = nil
        // Buttons' cornerRadius
        cell.firstButton.layer.cornerRadius = 10
        cell.secondButton.layer.cornerRadius = 10
        // ButtomLabel's backGroundColor
        cell.bottomLabel.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        // Cell's backGroundColor
        cell.setThemeColor()
        
        // Number of Cell that should be printed in CollectionView (data.count + 1[Empty Space])
        let cover_num = realm.objects(albumCover.self).count + 1
        
        // MARK: Set cells' Button Properties by indexPath & Number of Data
        // FIRST CASE :: 해당 row의 cell들이 전부 print 되어야 할 때
        if (indexPath.row + 1) * 2 <= cover_num {
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            // First Button
            if let firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first {
                if firstbuttonInfo.isCustomCover == false {
                    cell.firstButton.setImage(UIImage(named: firstbuttonInfo.coverImageName), for: .normal)
                } else {
                    let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(firstbuttonInfo.albumName)_CoverImage.jpeg", albumTitle: firstbuttonInfo.albumName)
                    cell.firstButton.setImage(customCoverImage, for: .normal)
                }
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 1
                LongPressGestureRecognizer.albumName = firstbuttonInfo.albumName
                cell.firstButton.addGestureRecognizer(LongPressGestureRecognizer)
            } else {
                print("RealmDB Error occur!")
            }
            // Second Button
            if let secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first {
                
                if secondbuttonInfo.isCustomCover == false {
                    cell.secondButton.setImage(UIImage(named: secondbuttonInfo.coverImageName), for: .normal)
                } else {
                    let customCoverImage = loadImageFromDocumentDirectory(imageName: "\(secondbuttonInfo.albumName)_CoverImage.jpeg", albumTitle: secondbuttonInfo.albumName)
                    cell.secondButton.setImage(customCoverImage, for: .normal)
                }
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
        
        // MARK: Set cell's button action properties
        // Callback1 :: First button Action
        cell.callback1 = {
            if cell.firstButton.imageView?.image == UIImage(systemName: "plus"){
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.collectionViewInHome = self.collectionView
                editVC.modalPresentationStyle = .overCurrentContext
                self.present(editVC, animated: false)
            } else {
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
                editVC.collectionViewInHome = self.collectionView
                editVC.modalPresentationStyle = .overCurrentContext
                self.present(editVC, animated: false)
            } else {
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as! AlbumScreenViewController
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
