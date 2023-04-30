import UIKit

class PageCell: UICollectionViewCell {
    // MARK: - Properties
    let button = PageButton()
    static let reuseIdentifier = "page-cell-resue-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageCell {
    // MARK: - Methods
    func configure() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        contentView.addSubview(button)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.clear
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}

class PageButton: UIButton {
    // MARK: - Properties
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    var pageNum: Int = -1
}
