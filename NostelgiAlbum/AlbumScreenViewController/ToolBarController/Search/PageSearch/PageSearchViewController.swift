import UIKit
import RealmSwift
// MARK: - Delegate
protocol PageDelegate {
    func scrollCenter()
}

class PageSearchViewController: UIViewController {
    var stackView: UIStackView!
    var collectionView: UICollectionView!
    var button: PageButton!
    var firstPicture: UILabel!
    var secondPicture: UILabel!
    var fpTitle: UILabel!
    var fpContent: UILabel!
    var spTitle: UILabel!
    var spContent: UILabel!
    
    var pageCount: Int = 0 // 전체 페이지 개수
    var didScroll: Bool = true // 버튼 누르기 전 스크롤을 수행했는지
    var previousButton: Int = -1
    var currentPageNum: Int = -1
    var delegate: SearchDelegate! = nil
    var pageButtonList = Array<PageButton>()
    var data: Results<album>! = nil
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarcy()
        
        
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
            loadPageInfo(btnPageNum: sender.pageNum)
            for i in 0...pageButtonList.count - 1 {
                if (sender.pageNum ) == i {
                    pageButtonList[i].backgroundColor = UIColor.blue
                } else {
                    pageButtonList[i].backgroundColor = UIColor.black
                }
            }
        }
    }
    // PageSearchView Dismiss
    @objc func exitSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true)
        }
    }
}
// CollectionView
extension PageSearchViewController {
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
    func configureCollectionView() -> UICollectionView {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = UIColor.white
        collectionView.clipsToBounds = true
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.layer.borderColor = UIColor.white.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.canCancelContentTouches = true
        return collectionView
    }
}

// StackView
extension PageSearchViewController {
    func configureHierarcy() {
        stackView = UIStackView(frame: view.bounds)
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.backgroundColor = UIColor.black
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        collectionView = configureCollectionView()
        stackView.addArrangedSubview(collectionView)
        
        button = configureButton()
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

    }
}

// Button & Label
extension PageSearchViewController {
    func configureButton() -> PageButton {
        let button = PageButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.heightAnchor.constraint(equalToConstant: stackView.frame.size.height/2.0).isActive = true
        
        firstPicture = UILabel()
        secondPicture = UILabel()
        firstPicture.translatesAutoresizingMaskIntoConstraints = false
        secondPicture.translatesAutoresizingMaskIntoConstraints = false
        firstPicture.numberOfLines = 0
        secondPicture.numberOfLines = 0
        firstPicture.layer.borderWidth = 1
        secondPicture.layer.borderWidth = 1
        firstPicture.layer.borderColor = UIColor.yellow.cgColor
        secondPicture.layer.borderColor = UIColor.white.cgColor
        firstPicture.textColor = UIColor.white
        secondPicture.textColor = UIColor.white
        button.addSubview(firstPicture)
        button.addSubview(secondPicture)
        NSLayoutConstraint.activate([
            firstPicture.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            firstPicture.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            firstPicture.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            firstPicture.bottomAnchor.constraint(equalTo: secondPicture.topAnchor, constant: -10),
            firstPicture.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.5), // Set the height of 'titles' to half the height of 'button'
            secondPicture.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            secondPicture.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            secondPicture.topAnchor.constraint(equalTo: firstPicture.bottomAnchor),
            secondPicture.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        fpTitle = UILabel()
        fpTitle.numberOfLines = 0
        fpContent = UILabel()
        fpContent.numberOfLines = 0
        fpTitle.translatesAutoresizingMaskIntoConstraints = false
        fpContent.translatesAutoresizingMaskIntoConstraints = false
        fpTitle.layer.borderColor = UIColor.white.cgColor
        fpTitle.layer.borderWidth = 1
        fpContent.layer.borderColor = UIColor.white.cgColor
        fpContent.layer.borderWidth = 1
        fpTitle.textColor = UIColor.white
        fpContent.textColor = UIColor.white
        firstPicture.addSubview(fpTitle)
        firstPicture.addSubview(fpContent)
        NSLayoutConstraint.activate([
            fpTitle.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpTitle.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpTitle.topAnchor.constraint(equalTo: firstPicture.topAnchor, constant: CGFloat(10)),
            fpTitle.bottomAnchor.constraint(equalTo: fpContent.topAnchor, constant: -CGFloat(5)),
            fpTitle.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.4),
            fpContent.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpContent.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpContent.topAnchor.constraint(equalTo: fpTitle.bottomAnchor, constant: CGFloat(5)),
            fpContent.bottomAnchor.constraint(equalTo: firstPicture.bottomAnchor, constant: CGFloat(10)),
            fpContent.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.4)
        ])
        
        spTitle = UILabel()
        spTitle.numberOfLines = 0
        spContent = UILabel()
        spContent.numberOfLines = 0
        spTitle.translatesAutoresizingMaskIntoConstraints = false
        spContent.translatesAutoresizingMaskIntoConstraints = false
        spTitle.layer.borderColor = UIColor.white.cgColor
        spTitle.layer.borderWidth = 1
        spContent.layer.borderColor = UIColor.white.cgColor
        spContent.layer.borderWidth = 1
        spTitle.textColor = UIColor.white
        spContent.textColor = UIColor.white
        secondPicture.addSubview(spTitle)
        secondPicture.addSubview(spContent)
        NSLayoutConstraint.activate([
            spTitle.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spTitle.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spTitle.topAnchor.constraint(equalTo: secondPicture.topAnchor, constant: CGFloat(10)),
            spTitle.bottomAnchor.constraint(equalTo: spContent.topAnchor, constant: -CGFloat(5)),
            spTitle.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.4),
            spContent.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spContent.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spContent.topAnchor.constraint(equalTo: spTitle.bottomAnchor, constant: CGFloat(5)),
            spContent.bottomAnchor.constraint(equalTo: secondPicture.bottomAnchor, constant: CGFloat(10)),
            spContent.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.4)
        ])
        
        return button
    }
}

extension PageSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pageCount + 5)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reuseIdentifier, for: indexPath) as! PageCell
        cell.button.setTitle("\(indexPath.item - 1)", for: .normal)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.button.titleLabel?.textColor = .white
        cell.button.pageNum = indexPath.item - 2
        cell.button.indexPath = indexPath
        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if indexPath.item < 2 || indexPath.item > pageCount + 2 {
            cell.button.isHidden = true
            cell.layer.isHidden = true
        } else {
            pageButtonList.append(cell.button)
        }
        if previousButton == cell.button.pageNum {
            cell.button.backgroundColor = UIColor.blue
        }
        return cell
        
    }
}

extension PageSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size for each item at the specified index path
        return CGSize(width: collectionView.bounds.width/6.0, height: collectionView.bounds.width/6.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return the section insets for the specified section
        return UIEdgeInsets(top: collectionView.bounds.height/1.5, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Return the minimum line spacing for the specified section
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Return the minimum interitem spacing for the specified section
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection here
        print("Selected item at index: \(indexPath.item)")
    }
}

// MARK: - PageDelegate
extension PageSearchViewController: PageDelegate{
    func scrollCenter() {
        let indexPath = IndexPath(item: currentPageNum + 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        loadPageInfo(btnPageNum: currentPageNum)
    }
}

// MARK: - CollectionViewDelegate
extension PageSearchViewController: UICollectionViewDelegate {
    // Check Scroll act
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didScroll = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initPageInfo()
    }
}

extension PageSearchViewController {
    func loadPageInfo(btnPageNum: Int) {
        let adnum = btnPageNum + 1
        let fpIndex = adnum * 2 - 2
        let spIndex = adnum * 2 - 1
        fpTitle.fadeTransition(0.4)
        fpContent.fadeTransition(0.4)
        spTitle.fadeTransition(0.4)
        spContent.fadeTransition(0.4)
        if fpIndex >= data.count {
            fpTitle.text = "empty"
            fpContent.text = "empty"
        } else {
            fpTitle.text = data[fpIndex].ImageName
            fpContent.text = data[fpIndex].ImageText
        }
        if spIndex > data.count {
            spTitle.text = "empty"
            spContent.text = "empty"
        } else {
            spTitle.text = data[spIndex].ImageName
            spContent.text = data[spIndex].ImageText
        }
    }
    func initPageInfo() {
        fpTitle.fadeTransition(0.4)
        fpContent.fadeTransition(0.4)
        spTitle.fadeTransition(0.4)
        spContent.fadeTransition(0.4)
        fpTitle.text = "empty"
        fpContent.text = "empty"
        spTitle.text = "empty"
        spContent.text = "empty"
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
