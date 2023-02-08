import UIKit
import RealmSwift

// HomeScreenViewController + CollectionView
extension HomeScreenViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
        // Set initial Image
        cell.firstButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cell.secondButton.setImage(UIImage(systemName: "plus"), for: .normal)
        // Set initial Gesture
        cell.firstButton.gestureRecognizers = nil
        cell.secondButton.gestureRecognizers = nil
        
        // Count number of albumCover
        // We have to count empty space to add new album
        // So we plus one more count!
        let cover_num = realm.objects(albumCover.self).count + 1
        
        // FIRST CASE :: ONE or TWO Albums in this row.
        if (indexPath.row + 1) * 2 <= cover_num {
            // Set both button that don't hide.
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = false
            // Find albumCover information that matches the button.
            // First Button :: Have to exist -> Set button
            if let firstbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 1)").first {
                cell.firstButton.setImage(UIImage(named: firstbuttonInfo.coverImageName), for: .normal)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 1
                LongPressGestureRecognizer.albumName = firstbuttonInfo.albumName
                cell.firstButton.addGestureRecognizer(LongPressGestureRecognizer)
            } else {
                print("RealmDB Error occur!")
            }
            // Second Button :: case1. Exist -> Set button
            // Second Button :: case2. Not Exist -> Doesn't Set button
            if let secondbuttonInfo = realm.objects(albumCover.self).filter("id = \(indexPath.row * 2 + 2)").first {
                cell.secondButton.setImage(UIImage(named: secondbuttonInfo.coverImageName), for: .normal)
                let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
                LongPressGestureRecognizer.albumIndex = indexPath.row * 2 + 2
                LongPressGestureRecognizer.albumName = secondbuttonInfo.albumName
                cell.secondButton.addGestureRecognizer(LongPressGestureRecognizer)
            }
        }
        // SECOND CASE :: NO Album in this row BUT previous row is full.
        else if (indexPath.row + 1) * 2 - 1 == cover_num{
            cell.firstButton.isHidden = false
            cell.secondButton.isHidden = true
        }
        // THIRD CASE :: NO Album in this row AND previous row is not full.
        else{
            cell.firstButton.isHidden = true
            cell.secondButton.isHidden = true
        }
        // Decide Button Action
        // Callback1 :: First button Action
        cell.callback1 = {
            if cell.firstButton.imageView?.image == UIImage(systemName: "plus"){
                let editVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeEditViewController") as! HomeEditViewController
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.collectionViewInHome = self.collectionView
                self.present(editVC, animated: false)
            }
            else {
                print("chop")
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

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
