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
  
  var sut: DevDetailsResponse!

  override func setUpWithError() throws {
    super.setUp()
    let data = try getData(fromJSON: "DevDetails_200")
    sut = try JSONDecoder().decode(DevDetailsResponse.self, from: data)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    super.tearDown()
  }
  
  func testJSONMapping() {
    XCTAssertEqual(sut.login, "ivey")
    XCTAssertNotEqual(sut.login, "louise")
  }

}
