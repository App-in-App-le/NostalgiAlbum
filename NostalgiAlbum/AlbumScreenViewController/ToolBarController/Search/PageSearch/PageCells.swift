import UIKit

class PageCell: UICollectionViewCell {
    // MARK: - Properties
    let button = PageButton()
    var index: Int!
    static let reuseIdentifier = "page-cell-resue-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        button.isHidden = false
        button.backgroundColor = UIColor.white
    }
}

extension PageCell {
    // MARK: - Methods
    func configure() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        contentView.addSubview(button)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

class PageButton: UIButton {
    // MARK: - Properties
    var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    var pageNum: Int = -1
}
