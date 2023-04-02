//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.02.2023.
//

import UIKit

class WatchListTableViewCell: UITableViewCell {
    // MARK: Identifier
    static let identifier = "WatchListTableViewCell"
    static let preferredHeight: CGFloat = 60

    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String
        let changeColor: UIColor
        let changePercentage: String
        let chartViewModel: StockChartView.ViewModel
    }

    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        chart.isUserInteractionEnabled = false
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.clipsToBounds = true
        contentView.addSubviews(symbolLabel, companyLabel, priceLabel, changeLabel, miniChartView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        symbolLabel.sizeToFit()
        companyLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()

        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = (contentView.height - symbolLabel.height - companyLabel.height) / 2

        NSLayoutConstraint.activate([
            symbolLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: horizontalPadding),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            symbolLabel.widthAnchor.constraint(equalToConstant: symbolLabel.width),
            symbolLabel.heightAnchor.constraint(equalToConstant: symbolLabel.height),

            companyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: horizontalPadding),
            companyLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor),
            companyLabel.widthAnchor.constraint(equalToConstant: companyLabel.width),
            companyLabel.heightAnchor.constraint(equalToConstant: companyLabel.height),

            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -horizontalPadding),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            priceLabel.widthAnchor.constraint(equalToConstant: priceLabel.width),
            priceLabel.heightAnchor.constraint(equalToConstant: priceLabel.height),

            changeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -horizontalPadding),
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            changeLabel.widthAnchor.constraint(equalToConstant: changeLabel.width),
            changeLabel.heightAnchor.constraint(equalToConstant: changeLabel.height),

            miniChartView.rightAnchor.constraint(equalTo: changeLabel.leftAnchor, constant: -horizontalPadding),
            miniChartView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            miniChartView.widthAnchor.constraint(equalToConstant: contentView.width / 3),
            miniChartView.heightAnchor.constraint(equalToConstant: contentView.height - verticalPadding*2),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }

    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor

        miniChartView.configure(with: viewModel.chartViewModel)
    }
}
