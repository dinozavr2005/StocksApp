//
//  MetricCollectionViewCell.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 31.03.2023.
//

import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
    static let identifier = "MetricCollectionViewCell"

    struct ViewModel {
        let name: String
        let value: String
    }

    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 10, y: 0, width: nameLabel.width, height: contentView.height)

        valueLabel.sizeToFit()
        valueLabel.frame = CGRect(x: nameLabel.right + 5, y: 0, width: valueLabel.width, height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }

    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name+":"
        valueLabel.text = viewModel.value
    }
}
