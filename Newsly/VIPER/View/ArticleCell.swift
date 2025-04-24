import UIKit

private enum LayoutConstants {
    static let cornerRadius: CGFloat = 8
    static let imageHeight: CGFloat = 180
    static let padding: CGFloat = 8
    static let titleFontSize: CGFloat = 16
    static let descFontSize: CGFloat = 14
    static let spacing: CGFloat = 8
    static let numberOfLines: Int = 2
}

class ArticleCell: UITableViewCell {
    static let identifier = "ArticleCell"

    let titleLabel = UILabel()
    let descLabel  = UILabel()
    private let newsImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.backgroundColor = .black

        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = LayoutConstants.cornerRadius
        newsImageView.backgroundColor = .darkGray

        titleLabel.font = .boldSystemFont(ofSize: LayoutConstants.titleFontSize)
        titleLabel.textColor = .systemTeal

        descLabel.font = .systemFont(ofSize: LayoutConstants.descFontSize)
        descLabel.textColor = .white
        descLabel.numberOfLines = LayoutConstants.numberOfLines

        let stack = UIStackView(arrangedSubviews: [newsImageView, titleLabel, descLabel])
        stack.axis = .vertical
        stack.spacing = LayoutConstants.spacing
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageHeight),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.padding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.padding),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstants.padding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.padding)
        ])
    }

    public func loadImage(from url: URL?) {
        newsImageView.startShimmering()
        newsImageView.image = nil
        guard let url = url else {
            newsImageView.stopShimmering()
            return
        }

        DispatchQueue.global().async { [weak self] in
            defer {
                DispatchQueue.main.async { self?.newsImageView.stopShimmering() }
            }
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.newsImageView.image = image
            }
        }
    }
}
