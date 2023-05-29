import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    // MARK: - Properties
    weak var albumScreenVC: AlbumScreenViewController! = nil
    var tableView: UITableView! = nil
    var tableCons: [NSLayoutConstraint]! = nil
    var index: Int!
    var font: String!
    
    // MARK: - Model
    let realm = try! Realm()
    // Section Header
    var section1_cellTitle: [String] = ["글꼴"]
    var section2_cellTitle: [String] = ["첫 페이지"]
    // Cell Description
    var section1_cellDescription: [String]! = nil
    var section2_cellDescription: [String]! = nil
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFont()
        setTableView()
        setTableViewHeader()
        setThemeColor()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Methods
    func loadFont() {
        let font_Kor = realm.objects(albumsInfo.self).filter("id = \(index!)").first!.font
        let font_Eng = FontSet().font[font_Kor]!
        font = font_Eng
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
        label.text = "설정"
        label.font = UIFont(name: self.font, size: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: header.bounds.height * 2, height: header.bounds.height))
        button.setTitle(" 앨범", for: .normal)
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

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "서식"
        case 1:
            return "페이지"
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
        let cell = SettingTableViewCell()
        
        switch indexPath.section {
        case 0:
            cell.setSubviews(title: section1_cellTitle[indexPath.item], font: self.font)
            if indexPath.item == 0 {
                cell.imageView?.image = UIImage(systemName: "textformat")
            }
        case 1:
            cell.setSubviews(title: section2_cellTitle[indexPath.item], font: self.font)
            if indexPath.item == 0 {
                cell.imageView?.image = UIImage(systemName: "bookmark.fill")
            }
        default:
            print("Error Occur")
        }
        
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // 글꼴
            if indexPath.item == 0 {
                let fontSettingVC = FontSettingViewController()
                fontSettingVC.index = index
                fontSettingVC.albumScreenVC = albumScreenVC
                fontSettingVC.settingVC = self
                
                self.navigationController?.pushViewController(fontSettingVC, animated: true)
            }
        case 1:
                if indexPath.item == 0 {
                let firstPageSettingVC = FirstPageSettingViewController()
                firstPageSettingVC.index = index
                
                self.navigationController?.pushViewController(firstPageSettingVC, animated: true)
            }
        default:
            print("Error Occur")
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
