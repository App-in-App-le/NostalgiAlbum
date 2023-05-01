import UIKit

class ContentsCells : UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "contents-cell-reuse-identifier"
    let button = PageButton()
    let title = UILabel()
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
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset/2.0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: inset/2.0),
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
        ])
        button.layer.cornerRadius = 15
        title.layer.cornerRadius = 10
        contents.layer.cornerRadius = 15
        title.clipsToBounds = true
        contents.clipsToBounds = true
        title.textColor = .white
        contents.textColor = .white
        setThemeColor()
    }
    // Label Configure
    func labelConfigure() {
        let titleText = UILabel()
        let contentsText = UILabel()
        titleText.text = "이름"
        contentsText.text = "내용"
        titleText.translatesAutoresizingMaskIntoConstraints = false
        contentsText.translatesAutoresizingMaskIntoConstraints = false
        titleText.backgroundColor = .white
        contentsText.backgroundColor = .white
        titleText.layer.cornerRadius = 10
        titleText.clipsToBounds = true
        contentsText.layer.cornerRadius = 10
        contentsText.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        contents.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        contents.numberOfLines = 2
//        title.layer.borderWidth = 1
//        title.layer.borderColor = UIColor.white.cgColor
//        contents.layer.borderWidth = 1
//        title.verticalAlignment = .top
        title.textAlignment = .center
        contents.verticalAlignment = .top
        titleText.textAlignment = .center
        contentsText.textAlignment = .center
        button.addSubview(title)
        button.addSubview(titleText)
        button.addSubview(contents)
        button.addSubview(contentsText)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(7)),
            title.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(7)),
            title.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: CGFloat(5)),
            title.bottomAnchor.constraint(equalTo: contentsText.topAnchor, constant: -CGFloat(5)),
            //title.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.2),
            
            titleText.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(7)),
            titleText.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(7)),
            titleText.topAnchor.constraint(equalTo: button.topAnchor, constant: CGFloat(7)),
            titleText.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -CGFloat(7)),
            titleText.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.3),
            titleText.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.1),
            
            contents.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(7)),
            contents.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(7)),
            contents.topAnchor.constraint(equalTo: contentsText.bottomAnchor, constant: CGFloat(5)),
            contents.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -CGFloat(10)),
            contents.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.5),
            
            contentsText.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(7)),
            contentsText.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(7)),
            contentsText.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CGFloat(7)),
            contentsText.bottomAnchor.constraint(equalTo: contents.topAnchor, constant: -CGFloat(7)),
            contentsText.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.3),
            contentsText.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.1),

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
                return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y + 5, width: rect.size.width, height: rect.size.height)
            }
        }
    }
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
