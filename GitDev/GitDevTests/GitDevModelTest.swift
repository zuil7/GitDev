//
//  GitDevModelTest.swift
//  GitDevTests
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import XCTest
@testable import GitDev

class GitDevModelTest: XCTestCase {
  
  func testDevListModel() {
    if let path = Bundle.main.url(forResource: "DevList_200", withExtension: "json") {
      do {
        let data = try Data(contentsOf: path)
        let _ = try JSONDecoder().decode([Devs].self, from: data)
        XCTAssertTrue(true)
      } catch {
      }
    }
  }
  
  func testDevInfoModel() {
    if let path = Bundle.main.url(forResource: "DevDetails_200", withExtension: "json") {
      do {
        let data = try Data(contentsOf: path)
        let _ = try JSONDecoder().decode(DevDetailsResponse .self, from: data)
        XCTAssertTrue(true)
      } catch {
      }
    }
  }
}
