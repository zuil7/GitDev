//
//  XCTestCase+JSON.swift
//  GitDevTests
//
//  Created by Louise Nicolas Namoc on 12/15/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import XCTest

extension XCTestCase {
  enum TestError: Error {
    case fileNotFound
  }
  
  func getData(fromJSON fileName: String) throws -> Data {
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
      XCTFail("Missing File: \(fileName).json")
      throw TestError.fileNotFound
    }
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      throw error
    }
  }
}

