import UIKit
import RealmSwift

class FirstPageSettingTableViewCell: UITableViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    var cellTitle: UILabel! = nil
    
    // MARK: - Methods
    func setSubviews(title: String, font: String) {
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.font = UIFont(name: font, size: 15)
        contentView.addSubview(cellTitle)
        
        self.imageView?.image = UIImage(systemName: "checkmark")
        self.imageView?.isHidden = true
        
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellTitle.leadingAnchor.constraint(equalTo: self.imageView!.trailingAnchor, constant: 10),
            cellTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
