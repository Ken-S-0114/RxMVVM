//
//  UserCell.swift
//  RxMVVM
//
//  Created by 佐藤賢 on 2019/01/28.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import UIKit
import GitHub

final class UserCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    private var task: URLSessionTask?

    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        task = nil
        imageView?.image = nil
    }

    func configure(user: User) {
        task = {
            let url = user.avatarURL
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }

                DispatchQueue.global().async { [weak self] in
                    guard let image = UIImage(data: imageData) else { return }

                    DispatchQueue.main.async {
                        self?.imageView?.image = image
                        self?.setNeedsLayout()
                    }
                }
            }
            task.resume()
            return task
        }()

        nameLabel.text = user.login
    }
    
}


