import UIKit

extension HomeScreenViewController {
        
    func pushShareView(path: URL) {
        print("chomozzi")
        let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        shareVC.filePath = path
        shareVC.collectionViewInHome = collectionView
        shareVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(shareVC, animated: true)
        //self.present(shareVC, animated: true)
    }
}
