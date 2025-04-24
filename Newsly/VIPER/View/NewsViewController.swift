import UIKit

class NewsViewController: UIViewController {

    // MARK: – VIPER Wiring
    var interactor: NewsInteractorInput!
    var router: NewsRouterInput!
    var presenter: NewsPresentationLogic!

    // MARK: – UI
    private let tableView = UITableView()
    private var items: [NewsViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Newsly"
        view.backgroundColor = .black
        setupTableView()
        interactor.fetchNews()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .black

        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc private func didPullToRefresh() {
        interactor.fetchNews()
    }
}

// MARK: – NewsViewInput

extension NewsViewController: NewsViewInput {
    func displayNews(_ viewModels: [NewsViewModel]) {
        self.items = viewModels
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func displayError(_ message: String) {
        tableView.refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: – UITableViewDataSource & Delegate

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tv: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: ArticleCell.identifier,
                                          for: indexPath) as! ArticleCell
        let vm = items[indexPath.row]
        cell.titleLabel.text = vm.title
        cell.descLabel.text  = vm.description
        cell.loadImage(from: vm.imageURL)
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        guard let url = items[indexPath.row].articleURL else { return }
        router.navigateToDetail(with: url)
    }

    func tableView(_ tv: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
                   -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { _, _, done in
            if let url = self.items[indexPath.row].articleURL {
                let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(ac, animated: true)
            }
            done(true)
        }
        share.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [share])
    }
}
