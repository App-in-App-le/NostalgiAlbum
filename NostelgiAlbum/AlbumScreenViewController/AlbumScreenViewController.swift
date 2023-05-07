import UIKit
import RealmSwift

class AlbumScreenViewController: UIViewController {
    // MARK: - Properties
    let realm = try! Realm()
    var pageNum : Int = 0
    var coverIndex : Int = 0
    var delegate: PageDelegate?
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var albumScreenVC: AlbumScreenViewController? = nil
    var isFontChanged: Bool = false
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        toolbarItems = makeToolbarItems()
        navigationController?.toolbar.tintColor = UIColor.label
        
        let titleName = UILabel()
        let albumName = realm.objects(albumCover.self).filter("id = \(coverIndex)").first!.albumName
        titleName.text = albumName
        titleName.textColor = .white
        titleName.font = UIFont.boldSystemFont(ofSize: 18)
        titleName.numberOfLines = 0
        titleName.sizeToFit()
        titleName.textAlignment = .center
        let widthConstraint = titleName.widthAnchor.constraint(equalToConstant: 200)
        widthConstraint.isActive = true
//        titleName.clipsToBounds = true
        print("size\(titleName.layer.frame.width)")
        navigationItem.titleView = titleName
        
        let pageNumButton = UIButton()
        pageNumButton.setTitle("\(pageNum + 1) 페이지", for: .normal)
        pageNumButton.setTitleColor(.white, for: .normal)
        pageNumButton.sizeToFit()
        pageNumButton.titleLabel?.sizeToFit()
        pageNumButton.addTarget(self, action: #selector(pageButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pageNumButton)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let backButtonImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(popToHome))
        backButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backButton
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        setThemeColor()
        setFont()
        
        print(titleName.font.fontName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Methods
    private func makeToolbarItems() -> [UIBarButtonItem]{
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.searchButton))
        searchButton.tintColor = .white
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.shareButton))
        shareButton.tintColor = .white
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.settingButton))
        settingButton.tintColor = .white
        
        let informationButton = UIBarButtonItem(image: UIImage(systemName: "info.square")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.infoButton))
        informationButton.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        flexibleSpace.tintColor = .white
        
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
        pageSearchVC.data = data
        pageSearchVC.index = coverIndex
        self.delegate = pageSearchVC //scrollCenter
        //pageSearchVC.modalPresentationStyle = .
        present(pageSearchVC, animated: true){
            self.delegate?.scrollCenter()
        }
    }
}
