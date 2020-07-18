import UIKit

@objc
final class IPFTestResultsViewController: UIViewController {
    var store: IPFTestResultsStoreType!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupUI() {
        title = "TestResults.title".localized
        tableView.register(IPFTestResultsCell.self, forCellReuseIdentifier: IPFTestResultsCell.reuseIdentifier)
        tableView.embed(in: view)
        tableView.estimatedRowHeight = rowHeight
        tableView.estimatedSectionHeaderHeight = rowHeight
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
