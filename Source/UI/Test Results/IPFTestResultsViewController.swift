import UIKit

@objc
final class IPFTestResultsViewController: UIViewController {
    var store: IPFTestResultsStoreType!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Private

    private func setupUI() {
        title = "TestResults.title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllTestResults))
        tableView.register(IPFTestResultsCell.self, forCellReuseIdentifier: IPFTestResultsCell.reuseIdentifier)
        tableView.embed(in: view)
        tableView.estimatedRowHeight = rowHeight
        tableView.estimatedSectionHeaderHeight = rowHeight
    }

    @objc private func deleteAllTestResults() {
        let alert = UIAlertController(title: "TestResults.deleteTitle".localized,
                                      message: "TestResults.deleteMessage".localizeWithFormat(arguments: store.results.count),
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK".localized, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.store.clear()
            self.tableView.reloadData()
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero))

    private let rowHeight: CGFloat = 60
}

extension IPFTestResultsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        store.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IPFTestResultsCell.reuseIdentifier, for: indexPath) as? IPFTestResultsCell else {
            return UITableViewCell()
        }

        cell.configure(with: store.results[indexPath.row])
        return cell
    }
}

extension IPFTestResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if #available(iOS 11.0, *) {
            return UITableView.automaticDimension
        } else {
            return rowHeight
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        if #available(iOS 11.0, *) {
            return UITableView.automaticDimension
        } else {
            return rowHeight
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let header = IPFTestResultsView()
        header.locationLabel.isHidden = true
        if #available(iOS 13.0, *) {
            header.backgroundColor = .systemGray5
        } else {
            header.backgroundColor = .lightGray
        }
        return header
    }
}
