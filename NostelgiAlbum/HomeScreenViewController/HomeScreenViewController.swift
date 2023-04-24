import UIKit
import RealmSwift

class HomeScreenViewController: UIViewController {
    // MARK: - Properties
    let realm = try! Realm()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeSettingButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        print("####path",Realm.Configuration.defaultConfiguration.fileURL!)
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
            for content in contents {
                print(content)
            }
        } catch {
            print("error")
        }
        if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                print(contents)
                for content in contents {
                    print(content)
                }
            } catch {
                print("error")
            }
        }
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
