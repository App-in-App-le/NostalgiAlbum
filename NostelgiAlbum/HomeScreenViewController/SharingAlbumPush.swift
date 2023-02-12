import UIKit

extension HomeScreenViewController {
    //HomeScreenViewController에서 ShareView를 push합니다.
    func pushShareView(path: URL) {
        let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        //.nost파일의 URL
        shareVC.filePath = path
        //HomeScreenViewController의 collectionView Object
        shareVC.collectionViewInHome = collectionView
        self.navigationController?.pushViewController(shareVC, animated: true)
    }
}
