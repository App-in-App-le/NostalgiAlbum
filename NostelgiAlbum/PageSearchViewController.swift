import UIKit

// MARK: - Delegate
protocol PageDelegate {
    func scrollCenter()
}

class PageSearchViewController: UIViewController {
    // MARK: - Properties
    var pageCount: Int = 0 // 전체 페이지 개수
    var didScroll: Bool = false // 버튼 누르기 전 스크롤을 수행했는지
    var previousButton: Int = -1
    var currentPageNum: Int = -1
    var delegate: SearchDelegate! = nil
    var label: UILabel! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    var uiView: UIView! = nil
    // For CollectionView DataSource section(임시)
    enum Section {
        case main
        case info
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        configureHierarcy()
        configureDataSource()
        
        // modal dismiss gesutre
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    // MARK: - Methods
    // Page Button Paging & Move Selected Page
    @objc func buttonTapped(_ sender: PageButton) {
        // Page Button이 View Center에 위치해있을 때 -> 선택된 페이지 이동
        if sender.pageNum == previousButton && didScroll {
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
        // 누른 Button이 가운데로 올 때까지 Scroll
        } else {
            collectionView.scrollToItem(at: sender.indexPath, at: .centeredHorizontally, animated: true)
            didScroll = true
            previousButton = sender.pageNum
        }
    }
    
    // PageSearchView Dismiss
    @objc func exitSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true)
        }
    }
}

// PageSearchViewController Extension - make collection view layout
extension PageSearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/5.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 300, leading: 0, bottom: 300, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
    
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        
        return layout
    }
    
}

// MARK: - PageSearchViewController Extension - Hierarcy & DataSource
extension PageSearchViewController {
    // make PageSearchView hierarcy(uiView & collectionView)
    private func configureHierarcy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        
        uiView = UIView(frame: view.bounds)
        uiView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        uiView.backgroundColor = UIColor.black
        uiView.alpha = 0.75
        view.addSubview(uiView)
        view.addSubview(collectionView)
    }
    // Set cell button properties
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PageCell, Int> { [self] (cell, indexPath, item) in
            cell.button.setTitle("\(item)", for: .normal)
            cell.button.pageNum = item - 1
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.button.titleLabel?.textAlignment = .center
            cell.button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            cell.button.indexPath = indexPath
            cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            if indexPath.item < 2 || indexPath.item > (pageCount + 2) {
                cell.button.isHidden = true
                cell.layer.isHidden = true
            }
        }
        // Set Section datasource
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        // Apple DataSource
        let pageArray = Array(-1...(pageCount+3))
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pageArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - CollectionViewDelegate
extension PageSearchViewController: UICollectionViewDelegate {
    // Check Scroll act
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didScroll = false
    }
}

// MARK: - PageDelegate
extension PageSearchViewController: PageDelegate{
    func scrollCenter() {
        let indexPath = IndexPath(item: currentPageNum + 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
