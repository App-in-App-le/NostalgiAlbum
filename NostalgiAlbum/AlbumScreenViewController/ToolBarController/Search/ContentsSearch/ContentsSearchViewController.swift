import UIKit

protocol SearchDelegate: AnyObject {
    func pushPage(currentPageNum: Int, targetPageNum: Int)
    func popPage(difBetCurTar: Int)
}

class ContentsSearchViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: SearchDelegate! = nil
    let contentsController = ContentsController()
    let contentsCells = ContentsCells()
    let searchBar = UISearchBar()
    var contentsSearchCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ContentsController.Search>!
    var coverIndex: Int = -1
    var pageCount: Int = 0
    var currentPageNum: Int = -1
    let backButton = UIButton()
    let topBorder = UIView()
    let bottomBorder = UIView()
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarcy()
        configureDataSource()
        performQuery(with: nil)
    }
    
    // MARK: - Methods
    // Move Page to searched page
    @objc func buttonTapped(_ sender: PageButton) {
        let movePageNum = sender.pageNum - currentPageNum
        if movePageNum == 0 {
            dismiss(animated: true)
        } else if movePageNum > 0 {
            dismiss(animated: false) {
                self.delegate?.pushPage(currentPageNum: self.currentPageNum + 1, targetPageNum: sender.pageNum)
            }
        } else {
            dismiss(animated: true) {
                self.delegate?.popPage(difBetCurTar: -(movePageNum - 1))
            }
        }
    }
    // dismiss ContentsSsearchView
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
