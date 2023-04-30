import UIKit

class ContentsCells : UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "contents-cell-reuse-identifier"
    let button = PageButton()
    let title = VerticalAlignLabel()
    let contents = VerticalAlignLabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentsCells {
    // MARK: - Methods
    // Button Configure
    func configure() {
        labelConfigure()
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.yellow.cgColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset/2.0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: inset/2.0),
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
        ])
    }
    // Label Configure
    func labelConfigure() {
        title.translatesAutoresizingMaskIntoConstraints = false
        contents.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        contents.numberOfLines = 0
        title.layer.borderWidth = 1
        contents.layer.borderWidth = 1
        title.verticalAlignment = .top
        contents.verticalAlignment = .top
        button.addSubview(title)
        button.addSubview(contents)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(5)),
            title.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(5)),
            title.topAnchor.constraint(equalTo: button.topAnchor, constant: CGFloat(10)),
            title.bottomAnchor.constraint(equalTo: contents.topAnchor, constant: -CGFloat(10)),
            title.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.4),
            
            contents.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(5)),
            contents.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(5)),
            contents.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CGFloat(5)),
            contents.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -CGFloat(10)),
            contents.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.4)
        ])
    }
}

class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
    }
    var verticalAlignment: VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            }
        }
    }
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
