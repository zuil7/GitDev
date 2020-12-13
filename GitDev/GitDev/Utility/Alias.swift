//
//  Alias.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

// Localization R swift shortcut
typealias S = R.string.localizable

// Empty Result + Void Return
typealias EmptyResult<ReturnType> = () -> ReturnType

// Custom Result + Custom Return
typealias SingleResultWithReturn<T, ReturnType> = ((T) -> ReturnType)

// Custom Result + Void Return
typealias SingleResult<T> = SingleResultWithReturn<T, Void>
typealias OnCompletionHandler<T> = ((T?, Error?) -> Void)
typealias ResultClosure<T> = ((T?, Bool, String?) -> Void)
typealias VoidResult = EmptyResult<Void> // () -> Void
