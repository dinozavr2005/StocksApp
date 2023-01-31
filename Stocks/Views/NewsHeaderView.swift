//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 31.01.2023.
//

import UIKit

class NewsHeaderView: UITableViewHeaderFooterView {

    static let identifier = "NewsHeaderView"
    static let preferredHeight: CGFloat = 70

    struct ViewModel {
        let title: String
        let shouldShowAddButtton: Bool
    }

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    public func configure(with viewModel: ViewModel) {
        
    }
}

