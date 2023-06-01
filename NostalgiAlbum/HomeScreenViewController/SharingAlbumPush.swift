import UIKit

extension HomeScreenViewController {
    func pushShareView(path: URL, checkFileProvider: Bool) {
        // 앨범을 공유 받았을 때, 출력되는 ViewController 생성
        let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        // 앨범을 공유 받은 경로 전달
        shareVC.filePath = path
        shareVC.collectionViewInHome = collectionView
        shareVC.checkFileProvider = checkFileProvider
        // 해당  shareVC를 Present
        shareVC.modalPresentationStyle = .overFullScreen
        self.present(shareVC, animated: false)
    }
    
}
