import UIKit
import RealmSwift

class HomeScreenViewController: UIViewController {
    // MARK: - Properties
    let realm = try! Realm()
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeSettingButton: UIButton!
    @IBOutlet weak var homeTitleView: UIView!
    @IBOutlet weak var NostelgiAlbumLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        print("####path",Realm.Configuration.defaultConfiguration.fileURL!)
        if realm.objects(HomeSetting.self).first == nil {
            let HomeSettingInfo = HomeSetting()
            try! realm.write {
                realm.add(HomeSettingInfo)
            }
        }
        setThemeColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
