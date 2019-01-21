//
//  SearchUserViewModel.swift
//  RxMVVM
//
//  Created by 佐藤賢 on 2019/01/21.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import RxSwift
import RxCocoa
import GitHub

final class SearchUserViewModel {

    private let searchUserModel: SearchUserModelProtocol
    private let disposeBag = DisposeBag()

    var users: [User] { return _user.value }

    private let _user = BehaviorRelay<[User]>(value: [])

    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToUserDetail: Observable<GitHub.User.Name>

    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         searchUserModel: SearchUserModelProtocol = SearchUserModel()) {

        self.searchUserModel = searchUserModel

        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _user.map { _ in }

    }
}
