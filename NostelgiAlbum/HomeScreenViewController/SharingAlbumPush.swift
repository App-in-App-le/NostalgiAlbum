import UIKit

extension HomeScreenViewController {
    func pushShareView(path: URL) {
        // Initialize shareViewController
        let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        // .nost file's path
        shareVC.filePath = path
        // Set collectionView in shareVC properties to reload Data
        shareVC.collectionViewInHome = collectionView
        // Push shareVC
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: false)
    }
    
}
