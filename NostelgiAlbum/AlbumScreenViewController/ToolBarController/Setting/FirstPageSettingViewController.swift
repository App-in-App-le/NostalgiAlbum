import UIKit
import RealmSwift

class FirstPageSettingViewController: UIViewController {
    // MARK: - Properties
    var tableView: UITableView! = nil
    var tableCons: [NSLayoutConstraint]! = nil
    var index: Int!
    var font: String!
    var firstPageSetting: Int! // 0: 첫 페이지, 1: 마지막 페이지, 2: 마지막으로 본 페이지
    
    // MARK: - Model
    let realm = try! Realm()
    // Section Header
    var section1_cellTitle: [String] = ["첫 페이지", "마지막 페이지", "마지막으로 본 페이지"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        loadFont()
        loadFirstPageSetting()
        setTableView()
        setTableViewHeader()
        setThemeColor()
    }
    
    // MARK: - Methods
    func loadFont() {
        let font_Kor = realm.objects(albumsInfo.self).filter("id = \(index!)").first!.font
        let font_Eng = FontSet().font[font_Kor]!
        font = font_Eng
    }
    
    func loadFirstPageSetting() {
        firstPageSetting = realm.objects(albumsInfo.self).filter("id = \(index!)").first?.firstPageSetting
    }
    
    func setTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableCons = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableCons)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setTableViewHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: header.frame.height))
        label.text = "첫 페이지"
        label.font = UIFont(name: self.font, size: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: header.bounds.height * 2, height: header.bounds.height))
        button.setTitle(" 설정", for: .normal)
        button.titleLabel?.font = UIFont(name: self.font, size: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        header.addSubview(label)
        header.addSubview(button)
        tableView.tableHeaderView = header
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension FirstPageSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "앨범 진입 방식 설정"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return section1_cellTitle.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FirstPageSettingTableViewCell()
        
        switch indexPath.section {
        case 0:
            cell.setSubviews(title: section1_cellTitle[indexPath.item], font: self.font)
            if indexPath.item == firstPageSetting {
                cell.imageView?.isHidden = false
            }
        default:
            print("Error Occur")
        }
        
        return cell
    }
}

extension FirstPageSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let firstPageSetting = indexPath.item
            let albumsInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
            if firstPageSetting != albumsInfo.firstPageSetting {
                do {
                    try realm.write {
                        albumsInfo.firstPageSetting = firstPageSetting
                    }
                } catch let error {
                    NSErrorHandling_Alert(error: error, vc: self)
                }
                // tableView 다시 그리기 -> 누른 Cell에 따라 설정 값에 체크를 넣어주기 위해
                loadFirstPageSetting()
                tableView.reloadData()
            }
        default:
            return
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: self.font, size: 14)
    }
}
