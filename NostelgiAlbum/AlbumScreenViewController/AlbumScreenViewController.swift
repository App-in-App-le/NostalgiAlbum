import UIKit
import RealmSwift

class AlbumScreenViewController: UIViewController {
    // MARK: - Properties
    let realm = try! Realm()
    var pageNum : Int = 0
    var coverIndex : Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        toolbarItems = makeToolbarItems()
        navigationController?.toolbar.tintColor = UIColor.label
        let pageNumLabel = UILabel()
        pageNumLabel.text = "\(pageNum + 1) Page"
        pageNumLabel.font = UIFont(name: "Bradley Hand", size: 20)
        pageNumLabel.textColor = .black
        pageNumLabel.sizeToFit()
        
        let titleName = UILabel()
        let albumName = realm.objects(albumCover.self).filter("id = \(coverIndex)").first?.albumName
        titleName.text = albumName
        titleName.font = UIFont(name: "Bradley Hand", size: 18)
        titleName.textColor = .black
        titleName.sizeToFit()
        
        navigationItem.titleView = titleName
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.square"), style: .plain, target: self, action: #selector(popToHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pageNumLabel)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Methods
    private func makeToolbarItems() -> [UIBarButtonItem]{
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.searchButton))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.shareButton))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: nil)
        let informationButton = UIBarButtonItem(image: UIImage(systemName: "info.square")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.infoButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        return [searchButton, flexibleSpace, shareButton, flexibleSpace, settingButton, flexibleSpace, informationButton]
    }
}
