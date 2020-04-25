//
//  IPFTestResultsViewController.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/24/20.
//

import UIKit

@objcMembers
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
        title = "Results"
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IPFTestResultsManager.shared.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IPFTestResultsCell.reuseIdentifier,
                                                       for: indexPath) as? IPFTestResultsCell else {
            return UITableViewCell()
        }

        cell.configure(with: IPFTestResultsManager.shared.results[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return IPFTestResultsHeaderView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

extension IPFTestResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
