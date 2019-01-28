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

    var users: [User] { return _users.value }

    private let _users = BehaviorRelay<[User]>(value: [])

    let deselectRow: Observable<IndexPath>
    let reloadData: Observable<Void>
    let transitionToUserDetail: Observable<GitHub.User.Name>

    init(searchBarText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         itemSelected: Observable<IndexPath>,
         searchUserModel: SearchUserModelProtocol = SearchUserModel()) {

        self.searchUserModel = searchUserModel

        self.deselectRow = itemSelected.map { $0 }
        self.reloadData = _users.map { _ in }

        self.transitionToUserDetail = itemSelected
            // Observable<IndexPath> のストリームに対し，BehaviorRelay<[User]> の最新値をくっつける
            // 起点である Observable<IndexPath>（ボタンが押された時）のみ発火
            .withLatestFrom(_users) { ($0, $1) }
            .flatMap { indexPath, users -> Observable<GitHub.User.Name> in
                guard indexPath.row < users.count else {
                    return .empty()
                }
                return .just(users[indexPath.row].strictName)
        }

        let searchResponse = searchButtonClicked
            .withLatestFrom(searchBarText)
            // subscribe 中の Observable が完了するまでの間に通知された Observable は無視
            .flatMapFirst { [weak self] text -> Observable<Event<[User]>> in
                guard let me = self, let query = text else { return .empty() }
                return me.searchUserModel
                    .fetchUser(query: query)
                    // Observable<Event<Void>> へ変換
                    .materialize()
            }
            .share()

        searchResponse
            .flatMap { event -> Observable<[User]> in
                event.element.map(Observable.just) ?? .empty()
            }
            // _users: BehaviorRelay<[User]> に値を反映
            .bind(to: _users)
            .disposed(by: disposeBag)

        searchResponse
            .flatMap { event -> Observable<Error> in
                event.error.map(Observable.just) ?? .empty()
            }
            .subscribe(onNext: { error in
                // TODO: Error Handling
            })
            .disposed(by: disposeBag)
    }
}
