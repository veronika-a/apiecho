//
//  TableInfoVC.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import Foundation
import UIKit

class TableInfoVC: UIViewController {
    private var tableView = UITableView()
    private var info: [String]?

    required init(info: [String]?) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
      }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        tableView.reloadData()
    }
}

extension TableInfoVC: UpdateData {
    func update() {
        tableView.reloadData()
    }
}

extension TableInfoVC {
    func createView() {
        view.backgroundColor = UIColor.white
        let tableView = createHistoryTableView()
        tableView.snp.makeConstraints {
            $0.right.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func createHistoryTableView() -> UITableView {
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 72
        return tableView
    }
}

// MARK: - TableView Delegates
extension TableInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "InfoTableViewCell", for: indexPath)
                as? InfoTableViewCell else { return UITableViewCell() }
        let info = info?[indexPath.row]
        cell.typeLabel.text = info ?? ""
        return cell
    }
}

protocol UpdateData {
    func update()
}
