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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
