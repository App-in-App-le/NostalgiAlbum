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
        if realm.objects(HomeSetting.self).first == nil {
            let HomeSettingInfo = HomeSetting()
            try! realm.write {
                realm.add(HomeSettingInfo)
            }
        }
        setThemeColor()
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
                    setThemeColorButton(pageButtonList[i])
                } else {
                    pageButtonList[i].backgroundColor = UIColor.white
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
        collectionView.clipsToBounds = true
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
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
        //stackView.spacing = 10
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
        button.heightAnchor.constraint(equalToConstant: stackView.frame.size.height/1.75).isActive = true

        firstPicture = UILabel()
        secondPicture = UILabel()
        firstPicture.translatesAutoresizingMaskIntoConstraints = false
        secondPicture.translatesAutoresizingMaskIntoConstraints = false
        firstPicture.numberOfLines = 0
        secondPicture.numberOfLines = 0
        firstPicture.textColor = UIColor.white
        secondPicture.textColor = UIColor.white
        firstPicture.layer.cornerRadius = 20
        secondPicture.layer.cornerRadius = 20
        firstPicture.clipsToBounds = true
        secondPicture.clipsToBounds = true
        button.addSubview(firstPicture)
        button.addSubview(secondPicture)
        NSLayoutConstraint.activate([
            firstPicture.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            firstPicture.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            firstPicture.topAnchor.constraint(equalTo: button.topAnchor, constant: 1),
            firstPicture.bottomAnchor.constraint(equalTo: secondPicture.topAnchor, constant: -10),
            firstPicture.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.45),
            secondPicture.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            secondPicture.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            secondPicture.topAnchor.constraint(equalTo: firstPicture.bottomAnchor, constant: 1),
            secondPicture.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            secondPicture.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.45)
        ])
        fpTitle = paddingLabel()
        fpTitle.numberOfLines = 0
        fpContent = paddingLabel()
        fpContent.numberOfLines = 0
        fpTitle.translatesAutoresizingMaskIntoConstraints = false
        fpContent.translatesAutoresizingMaskIntoConstraints = false
        fpTitle.textColor = UIColor.white
        fpContent.textColor = UIColor.white
        fpTitle.clipsToBounds = true
        fpContent.clipsToBounds = true
        fpTitle.layer.cornerRadius = 15
        fpContent.layer.cornerRadius = 15
        let fpTitleText = paddingLabel()
        let fpContentText = paddingLabel()
        fpTitleText.numberOfLines = 1
        fpContentText.numberOfLines = 0
        fpTitleText.translatesAutoresizingMaskIntoConstraints = false
        fpContentText.translatesAutoresizingMaskIntoConstraints = false
        fpTitleText.text = "이름"
        fpContentText.text = "내용"
        firstPicture.addSubview(fpTitleText)
        firstPicture.addSubview(fpContentText)
        firstPicture.addSubview(fpTitle)
        firstPicture.addSubview(fpContent)
        NSLayoutConstraint.activate([
            fpTitle.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpTitle.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpTitle.topAnchor.constraint(equalTo: fpTitleText.bottomAnchor, constant: CGFloat(10)),
            fpTitle.bottomAnchor.constraint(equalTo: fpContentText.topAnchor, constant: -CGFloat(5)),
            fpTitle.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.2),
            
            fpContent.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpContent.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpContent.topAnchor.constraint(equalTo: fpContentText.bottomAnchor, constant: CGFloat(5)),
            fpContent.bottomAnchor.constraint(equalTo: firstPicture.bottomAnchor, constant: CGFloat(10)),
            fpContent.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.4),
            
            fpTitleText.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpTitleText.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpTitleText.topAnchor.constraint(equalTo: firstPicture.topAnchor, constant: CGFloat(10)),
            fpTitleText.bottomAnchor.constraint(equalTo: fpTitle.topAnchor, constant: -CGFloat(5)),
            fpTitleText.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.1),
            
            fpContentText.leadingAnchor.constraint(equalTo: firstPicture.leadingAnchor, constant: CGFloat(20)),
            fpContentText.trailingAnchor.constraint(equalTo: firstPicture.trailingAnchor, constant: -CGFloat(20)),
            fpContentText.topAnchor.constraint(equalTo: fpTitle.bottomAnchor, constant: CGFloat(10)),
            fpContentText.bottomAnchor.constraint(equalTo: fpContent.topAnchor, constant: -CGFloat(5)),
            fpContentText.heightAnchor.constraint(equalTo: firstPicture.heightAnchor, multiplier: 0.1)
        ])
        
        spTitle = paddingLabel()
        spTitle.numberOfLines = 0
        spContent = paddingLabel()
        spContent.numberOfLines = 0
        spTitle.translatesAutoresizingMaskIntoConstraints = false
        spContent.translatesAutoresizingMaskIntoConstraints = false
        spTitle.textColor = UIColor.white
        spContent.textColor = UIColor.white
        spTitle.clipsToBounds = true
        spContent.clipsToBounds = true
        spTitle.layer.cornerRadius = 15
        spContent.layer.cornerRadius = 15
        let spTitleText = paddingLabel()
        let spContentText = paddingLabel()
        spTitleText.numberOfLines = 1
        spContentText.numberOfLines = 0
        spTitleText.translatesAutoresizingMaskIntoConstraints = false
        spContentText.translatesAutoresizingMaskIntoConstraints = false
        spTitleText.text = "이름"
        spContentText.text = "내용"

        secondPicture.addSubview(spTitle)
        secondPicture.addSubview(spContent)
        secondPicture.addSubview(spTitleText)
        secondPicture.addSubview(spContentText)
        NSLayoutConstraint.activate([
            spTitle.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spTitle.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spTitle.topAnchor.constraint(equalTo: spTitleText.bottomAnchor, constant: CGFloat(10)),
            spTitle.bottomAnchor.constraint(equalTo: spContentText.topAnchor, constant: -CGFloat(5)),
            spTitle.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.2),
            
            spContent.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spContent.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spContent.topAnchor.constraint(equalTo: spContentText.bottomAnchor, constant: CGFloat(5)),
            spContent.bottomAnchor.constraint(equalTo: secondPicture.bottomAnchor, constant: CGFloat(10)),
            spContent.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.4),
            
            spTitleText.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spTitleText.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spTitleText.topAnchor.constraint(equalTo: secondPicture.topAnchor, constant: CGFloat(10)),
            spTitleText.bottomAnchor.constraint(equalTo: spTitle.topAnchor, constant: -CGFloat(5)),
            spTitleText.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.1),
            
            spContentText.leadingAnchor.constraint(equalTo: secondPicture.leadingAnchor, constant: CGFloat(20)),
            spContentText.trailingAnchor.constraint(equalTo: secondPicture.trailingAnchor, constant: -CGFloat(20)),
            spContentText.topAnchor.constraint(equalTo: spTitle.bottomAnchor, constant: CGFloat(10)),
            spContentText.bottomAnchor.constraint(equalTo: spContent.topAnchor, constant: -CGFloat(5)),
            spContentText.heightAnchor.constraint(equalTo: secondPicture.heightAnchor, multiplier: 0.1)
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
        let themaColorSetInstance = ThemeColorSet()
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        
        if previousButton == cell.button.pageNum {
            if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
                cell.button.backgroundColor = ThemeColorSet["subColor_4"]
            }
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
        return UIEdgeInsets(top: collectionView.bounds.height/1.5, left: 10, bottom: 20, right: 10)
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
        if spIndex >= data.count {
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

class paddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
