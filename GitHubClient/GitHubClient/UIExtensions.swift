//
//  UIExtensions.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/4/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
