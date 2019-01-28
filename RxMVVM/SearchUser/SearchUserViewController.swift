//
//  SearchUserViewController.swift
//  RxMVVM
//
//  Created by 佐藤賢 on 2019/01/21.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import UIKit
import GitHub
import RxSwift
import RxCocoa

class SearchUserViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var viewModel = SearchUserViewModel(
        searchBarText: searchBar.rx.text.asObservable(),
        searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
        itemSelected: tableView.rx.itemSelected.asObservable()
    )

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        // ViewModel の値が変化したとき，リロードする
        viewModel.deselectRow
            .bind(to: deselectRow)
            .disposed(by: disposeBag)

        // ViewModel の値が変化したとき，リロードする
        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }

}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        let user = viewModel.users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}

extension SearchUserViewController {
    private var deselectRow: Binder<IndexPath> {
        return Binder(self) { me, indexPath in
            me.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }
    }


}
