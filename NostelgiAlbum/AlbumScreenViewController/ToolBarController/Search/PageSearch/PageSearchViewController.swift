import UIKit
import RealmSwift
// MARK: - Delegate
protocol PageDelegate: AnyObject {
    func scrollCenter()
}

class PageSearchViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: SearchDelegate! = nil
    var stackView: UIStackView!
    var collectionView: PageCollectionView!
    var button: PageButton!
    var firstPicture = UILabel()
    var secondPicture = UILabel()
    var fpTitle = paddingLabel()
    var fpContent = VerticalAlignLabel()
    var spTitle = paddingLabel()
    var spContent = VerticalAlignLabel()
    let fpTitleText = paddingLabel()
    let fpContentText = paddingLabel()
    let spTitleText = paddingLabel()
    let spContentText = paddingLabel()
    var pageCount: Int = 0 // 전체 페이지 개수
    var didScroll: Bool = true // 버튼 누르기 전 스크롤을 수행했는지
    var previousButton: Int = -1
    var currentPageNum: Int = -1
    var pageButtonList = Array<PageButton>()
    var data: Results<album>! = nil
    var index: Int!
    let realm = try! Realm()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarcy()
        setThemeColor()
        setFont()
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
    @objc func bottomButtonTapped(_ sender: PageButton) {
        if sender.pageNum != -1 {
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
    }
    // PageSearchView Dismiss
    @objc func exitSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true)
        }
    }
    
}

extension PageSearchViewController {
    // PageCell에 페이지 내부 사진 정보 load
    func loadPageInfo(btnPageNum: Int) {
        let adnum = btnPageNum + 1
        let fpIndex = adnum * 2 - 2
        let spIndex = adnum * 2 - 1
        button.pageNum = btnPageNum
        if fpIndex >= data.count {
            UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.firstPicture.isHidden = true
            }, completion: nil)
            fpTitle.text = "empty"
            fpContent.text = "empty"
        } else {
            if firstPicture.isHidden {
                UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.firstPicture.isHidden = false
                }, completion: nil)
            } else {
                fpTitle.fadeTransition(0.4)
                fpContent.fadeTransition(0.4)
            }
            fpTitle.text = data[fpIndex].ImageName
            fpContent.text = data[fpIndex].ImageText
        }
        if spIndex >= data.count {
            spTitle.text = "empty"
            spContent.text = "empty"
            UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.secondPicture.isHidden = true
            }, completion: nil)
        } else {
            if secondPicture.isHidden {
                UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.secondPicture.isHidden = false
                }, completion: nil)
            } else {
                spTitle.fadeTransition(0.4)
                spContent.fadeTransition(0.4)
            }
            spTitle.text = data[spIndex].ImageName
            spContent.text = data[spIndex].ImageText
            

        }
    }
    func initPageInfo() {
        button.pageNum = -1
        // 데이터가 없을 시(초기 상태 & 스크롤할 때)
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.firstPicture.isHidden = true
        }, completion: nil)
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.secondPicture.isHidden = true
        }, completion: nil)

    }
}

// custom CollectionView 버튼의 자연스런 스크롤을 위해
class PageCollectionView: UICollectionView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
