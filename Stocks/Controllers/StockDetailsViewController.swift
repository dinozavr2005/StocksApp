//
//  StockDetailsViewController.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import SafariServices
import UIKit

class StockDetailsViewController: UIViewController {

    // MARK: - Properties
    
    private let symbol: String
    private let companyName: String
    private var candleStickData: [CandleStick]

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        return table
    }()

    private var stories: [NewsStory] = []
    // MARK: - Init

    init(
        symbol: String,
        companyName: String,
        candleStickData: [CandleStick] = []
    ) {
            self.symbol = symbol
            self.companyName = companyName
            self.candleStickData = candleStickData
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = companyName
        setUpCloseButton()
        setUpTable()
        fetchFinancialData()
        fetchNews()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    private func  setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: view.width, height: (view.width * 0.7) + 100))
    }

    private func fetchFinancialData() {
        let group = DispatchGroup()
        if candleStickData.isEmpty {
            group.enter()
        }
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                let metrics = response.metric
                print(metrics)
            case .failure(let error):
                print(error)
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.renderChart()
        }
    }

    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func renderChart() {
        let headerView = StockDetailHeaderView(frame: CGRect(x: 0, y: 0,
                                                             width: view.width, height: (view.width * 0.7) + 100))
        tableView.tableHeaderView = headerView
    }



}

// MARK: - Add To Watchlist

extension StockDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
//
//        HapticsService.shared.vibrate(for: .success)

        let alert = UIAlertController(title: "Added to watchlist", message: "We've added \(companyName) to your watchlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - TableView Delegates

extension StockDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else {
            return nil
        }
        header.delegate = self
        header.configure(with: .init(title: symbol.uppercased(),
                                     shouldShowAddButtton: !PersistenceManager.shared.watchlistContains(symbol: symbol)))
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        HapticsService.shared.vibrateForSelection()

        guard let url = URL(string: stories[indexPath.row].url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
