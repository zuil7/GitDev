//
//  ImageCacheConfig.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

struct ImageCacheConfig {
    let countLimit: Int
    let memoryLimit: Int

    static let defaultConfig = ImageCacheConfig(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
}
