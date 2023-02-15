//
//  NewsViewController.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import UIKit

final class NewsViewController: UIViewController {

    private let type: `Type`

    enum `Type` {
        case topStories
        case company(symbol: String)

        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }

    // MARK: - Properties

    private var stories: [NewsStory] = [
        NewsStory(category: "tech", datetime: 123, headline: "Some headline", id: 1, image: "", related: "Related", source: "SNBC", summary: "", url: "")
        ]

    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return table
    }()

    // MARK: - Init

    init(type: `Type`) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        fetchNews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Private

    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchNews() {

    }

    private func open(url: URL) {

    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier,
                                                       for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.configure(with: .init(title: self.type.title, shouldShowAddButtton: false))
        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
