import UIKit
import RealmSwift

class SettingTableViewCell: UITableViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    var cellTitle: UILabel! = nil
    var backButtonImage: UIImageView! = nil
    
    // MARK: - Methods
    func setSubviews(title: String, font: String) {
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.font = UIFont(name: font, size: 15)
        contentView.addSubview(cellTitle)
        
        backButtonImage = UIImageView()
        backButtonImage.image = UIImage(systemName: "chevron.right")
        backButtonImage.tintColor = .systemGray2
        contentView.addSubview(backButtonImage)
        
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        backButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: self.imageView!.trailingAnchor, constant: 10),
            cellTitle.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 3),
            
            backButtonImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backButtonImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }
}
