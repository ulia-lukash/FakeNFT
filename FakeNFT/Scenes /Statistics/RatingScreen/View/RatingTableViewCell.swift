import UIKit

final class RatingCell: UITableViewCell {
    private let ratingPositionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .yellow
        selectionStyle = .none

        setupRatingPositionLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRatingPositionLabel() {
        contentView.addSubview(ratingPositionLabel)
        NSLayoutConstraint.activate([
            ratingPositionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingPositionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        ])
    }
}
