import UIKit

// - MARK: shareView push에 관련된 함수를 선언한 Extension
extension HomeScreenViewController {
    
    // - MARK: ShareViewController를 만들어 navigationController에 push하는 함수
    func pushShareView(path: URL) {
        
        // [1] Share View Controller 생성
        let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        
        // [2] nost 파일의 path를 shareVC의 filePath 프로퍼티에 저장
        shareVC.filePath = path
        
        // [3] HomeScreenViewController의 collectionView Object를 shareVC의 프로퍼티에 저장
        shareVC.collectionViewInHome = collectionView
        
        // [4] shareVC를 push
        self.navigationController?.pushViewController(shareVC, animated: true)
    }
    
}
