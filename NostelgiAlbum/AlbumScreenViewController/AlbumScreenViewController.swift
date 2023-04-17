import UIKit
import RealmSwift

class AlbumScreenViewController: UIViewController {
    let realm = try! Realm()
    var pageNum : Int = 0
    var coverIndex : Int = 0
    var delegate: PageDelegate?
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        toolbarItems = makeToolbarItems()
        navigationController?.toolbar.tintColor = UIColor.label
        let pageNumButton = UIButton()
        pageNumButton.setTitle("\(pageNum + 1) Page", for: .normal)
        pageNumButton.titleLabel?.font = UIFont(name: "Bradley Hand", size: 20)
        pageNumButton.setTitleColor(.black, for: .normal)
        pageNumButton.titleLabel?.sizeToFit()
        pageNumButton.addTarget(self, action: #selector(pageButtonTapped), for: .touchUpInside)
        let titleName = UILabel()
        let albumName = realm.objects(albumCover.self).filter("id = \(coverIndex)").first?.albumName
        titleName.text = albumName
        titleName.font = UIFont(name: "Bradley Hand", size: 18)
        titleName.textColor = .black
        titleName.sizeToFit()
        
        navigationItem.titleView = titleName
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.square"), style: .plain, target: self, action: #selector(popToHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pageNumButton)
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

extension AlbumScreenViewController {
    @objc func pageButtonTapped() {
        guard let pageSearchVC = self.storyboard?.instantiateViewController(withIdentifier: "PageSearchViewController") as? PageSearchViewController else { return }
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        pageSearchVC.pageCount = (data.count/2)
        pageSearchVC.currentPageNum = pageNum
        pageSearchVC.delegate = self //push, pop
        pageSearchVC.previousButton = pageNum
        self.delegate = pageSearchVC //scrollCenter
        pageSearchVC.modalPresentationStyle = .overCurrentContext
        present(pageSearchVC, animated: true){
            self.delegate?.scrollCenter()
        }
    }
}
