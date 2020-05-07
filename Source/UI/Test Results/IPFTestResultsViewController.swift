//
//  IPFTestResultsViewController.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/24/20.
//

import UIKit

@objc
final class IPFTestResultsViewController: UIViewController {
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
        tableView.estimatedRowHeight = 50
    }

    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero))
}

extension IPFTestResultsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        IPFTestResultsManager.shared.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IPFTestResultsCell.reuseIdentifier, for: indexPath) as? IPFTestResultsCell else {
            return UITableViewCell()
        }

        cell.configure(with: IPFTestResultsManager.shared.results[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        IPFTestResultsHeaderView()
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        44
    }
}

extension IPFTestResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
