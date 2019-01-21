//
//  User+Extension.swift
//  RxMVVM
//
//  Created by 佐藤賢 on 2019/01/21.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import GitHub

extension GitHub.User {
    struct Name {
        let rawValue: String
    }

    var strictName: Name {
        return Name(rawValue: login)
    }
}
