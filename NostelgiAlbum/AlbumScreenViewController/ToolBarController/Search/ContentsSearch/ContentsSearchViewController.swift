import UIKit

protocol SearchDelegate{
    func pushPage(currentPageNum: Int, targetPageNum: Int)
    func popPage(difBetCurTar: Int)
}

class ContentsSearchViewController: UIViewController {
    
    let contentsController = ContentsController()
    let searchBar = UISearchBar()
    var contentsSearchCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ContentsController.Search>!
    var coverIndex: Int = -1
    var pageCount: Int = 0
    var currentPageNum: Int = -1
    var delegate: SearchDelegate! = nil
    
    enum Section: CaseIterable {
        case main
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarcy()
        configureDataSource()
        performQuery(with: nil)
        // modal dismiss gesutre
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeRecognizer)
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
    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.dismiss(animated: true)
        }
    }
}
// ContentsSearchViewController - Manage DataSource & Reload Data
extension ContentsSearchViewController {
    func configureDataSource() {
        contentsController.coverIndex = coverIndex
        let cellRegistration = UICollectionView.CellRegistration<ContentsCells, ContentsController.Search> {
            [self] (cell, indexPath, search) in
            cell.button.pageNum = search.page
            cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            cell.title.text = search.name
            cell.contents.text = search.contents
        }
        dataSource = UICollectionViewDiffableDataSource<Section, ContentsController.Search>(collectionView: contentsSearchCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ContentsController.Search) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    func performQuery(with filter: String?) {
        let searches = contentsController.filteredSearch(with: filter).sorted { $0.page < $1.page }
        var snapshot = NSDiffableDataSourceSnapshot<Section, ContentsController.Search>()
        snapshot.appendSections([.main])
        snapshot.appendItems(searches)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
// ContentsSearchViewController Extension - make collection view layout
extension ContentsSearchViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0/1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/2.0), heightDimension: .absolute(70))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        return layout
    }
    
    func configureHierarcy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        let views = ["cv": collectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[cv]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[searchBar]-20-[cv]|", options: [], metrics: nil, views: views))
        constraints.append(searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
        contentsSearchCollectionView = collectionView
        
        searchBar.delegate = self
    }
}

extension ContentsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}
