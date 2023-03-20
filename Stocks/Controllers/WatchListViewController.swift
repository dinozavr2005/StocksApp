//
//  ViewController.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import UIKit
import FloatingPanel

final class WatchListViewController: UIViewController {

    private var searchTimer: Timer?

    private var panel: FloatingPanelController?

    private var watchlistMap: [String: [CandleStick]] = [:]

    private var viewModels: [WatchListTableViewCell.ViewModel] = []

    private let tableView: UITableView = {
        let table = UITableView()

        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setUpSearchController()
        setUpTableView()
        fetchWatchListData()
        setUpFloatingPanel()
        setUpTitleVIew()
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setUpFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
    }

    private func setUpTitleVIew() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20 , height: titleView.height))
        label.text = "Stocks"
        titleView.addSubview(label)
        label.font = .systemFont(ofSize: 40, weight: .medium)
        navigationItem.titleView = titleView
        
    }

    // MARK: - Private

    private func fetchWatchListData() {
        let symbols = PersistenceManager.shared.watchlist

        let group = DispatchGroup()

        for symbol in symbols {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }

                switch result {
                case.success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
            self?.createViewModels()
        }
    }

    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()

        for (symbol, candleSticks) in watchlistMap {
            viewModels.append(
                .init(symbol: symbol,
                      companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                      price: getLatestClosingPrice(from: candleSticks),
                      changeColor: <#T##UIColor#>,
                      changePercentage: <#T##String#>)
            )
        }

        self.viewModels = viewModels
    }

    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
    }

    private func setUpSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }

}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // Reset timer
        searchTimer?.invalidate()
        //Kick off new timer
        
        //Optimaze to reduce numbers of searching
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // Call API to search
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    // Update results controller
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })



    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        // Present stock details
        let vc = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMap.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
