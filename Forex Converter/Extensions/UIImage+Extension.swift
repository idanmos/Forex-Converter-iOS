//
//  UIImage+Extension.swift
//  Forex Converter
//
//  Created by Idan Moshe on 06/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
