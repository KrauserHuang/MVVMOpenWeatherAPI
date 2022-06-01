//
//  Extensions.swift
//  MVVMOpenWeatherAPI
//
//  Created by Tai Chin Huang on 2022/6/1.
//

import Foundation
import UIKit

extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
