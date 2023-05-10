import UIKit
import RealmSwift

class FontSettingViewController: UIViewController {
    // MARK: - Properties
    weak var albumScreenVC: AlbumScreenViewController! = nil
    weak var settingVC: SettingViewController! = nil
    var tableView: UITableView! = nil
    var tableCons: [NSLayoutConstraint]! = nil
    var font: String!
    var index: Int!
    
    // MARK: - Model
    let realm = try! Realm()
    // Section Header
    var section1_cellTitle: [String] = []
    var section2_cellTitle: [String] = ["지마켓 산스체", "수박 화체", "평창평화체"]
    // Cell Description
    var section1_cellDescription: [String]! = nil
    var section2_cellDescription: [String]! = nil
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        loadFont()
        setTableView()
        setTableViewHeader()
        setThemeColor()
    }
    
    // MARK: - Methods
    func loadFont() {
        font = realm.objects(albumsInfo.self).filter("id = \(index!)").first!.font
        section1_cellTitle = [font]
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
        label.text = "글꼴"
        label.font = UIFont(name: FontSet().font[section1_cellTitle[0]]!, size: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: header.bounds.height * 2, height: header.bounds.height))
        button.setTitle(" 설정", for: .normal)
        button.titleLabel?.font = UIFont(name: FontSet().font[section1_cellTitle[0]]!, size: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        header.addSubview(label)
        header.addSubview(button)
        tableView.tableHeaderView = header
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FontSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "현재 글꼴"
        case 1:
            return "글꼴"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return section1_cellTitle.count
        case 1:
            return section2_cellTitle.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FontSettingTableViewCell()
        let fontSet = FontSet().font
        
        switch indexPath.section {
        case 0:
            cell.setSubviews(title: section1_cellTitle[indexPath.item],
                             titleFont: fontSet[section1_cellTitle[0]]!,
                             descriptionFont: fontSet[section1_cellTitle[indexPath.item]]!)
            cell.selectionStyle = .none
        case 1:
            cell.setSubviews(title: section2_cellTitle[indexPath.item],
                             titleFont: fontSet[section1_cellTitle[0]]!,
                             descriptionFont: fontSet[section2_cellTitle[indexPath.item]]!)
        default:
            print("Error Occur")
        }
        
        return cell
    }
}

extension FontSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath.section {
        case 0:
            return
        case 1:
            let selected_font_cell = tableView.cellForRow(at: indexPath) as! FontSettingTableViewCell
            
            let selected_font = GetKorFontName(engFontName: selected_font_cell.cellDescription.font.fontName)
            
            let albumsInfo = realm.objects(albumsInfo.self).filter("id = \(index!)").first!
            
            // 현재 글꼴 변경 시, 표시하도록 하는 부분
            if albumsInfo.font != selected_font {
                try! realm.write {
                    albumsInfo.font = selected_font
                }
                // Navigation으로 Push 했기 때문에 Pop하기 전에 글꼴을 바꿔주어야 한다.
                // 현재 페이지 글꼴 바꾸기
                loadFont()
                tableView.tableHeaderView = nil
                setTableViewHeader()
                tableView.reloadData()
                // 앨범 설정 페이지 글꼴 바꾸기
                settingVC.loadFont()
                settingVC.tableView.tableHeaderView = nil
                settingVC.setTableViewHeader()
                settingVC.tableView.reloadData()
                // 앨범 페이지 글꼴 바꾸기
                albumScreenVC.isFontChanged = true
                albumScreenVC.setFont()
                albumScreenVC.collectionView.reloadData()
            } else {
                tableView.cellForRow(at: indexPath)?.isSelected = false
            }
        default:
            print("Error Occur")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: FontSet().font[section1_cellTitle[0]]!, size: 14)
    }
}
