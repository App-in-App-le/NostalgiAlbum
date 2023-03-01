import UIKit
import RealmSwift

// - MARK: HomeScreenViewController
class HomeScreenViewController: UIViewController {
    
    // - MARK: RealmDB 관련 변수 및 CollectionView 변수 선언
    let realm = try! Realm()
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - MARK: viewDidLoad :: view가 Load될 때
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // RealmDB 파일이 저장된 경로 출력
        print("####path",Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    // - MARK: viewWillAppear :: view가 나타날 때
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // - MARK: viewWillDisappear :: view가 사라질 때
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

