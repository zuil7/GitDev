//
//  GitDevTests.swift
//  GitDevTests
//
//  Created by Louise Namoc.
//  Copyright © 2020 Louise Namoc. All rights reserved.
//

import XCTest
@testable import GitDev

class GitDevTests: XCTestCase {

  private var viewModel = DevListViewModel(task: DevListService())
  private var devDetailViewModel = DevDetailViewModel(task: DevDetailsService())

  func testDevList() {
    let expect = expectation(description: "Get Developer List")
    viewModel.requestDevList { (status) in
      XCTAssertTrue(status)
      expect.fulfill()
    } onError: { (err) in }
    waitForExpectations(timeout: 5, handler: .none)
  }
  
  func testDevInfo() {
    let expect = expectation(description: "Get Developer Details")
    devDetailViewModel.requestDevInfo{ (status) in
      XCTAssertTrue(status)
      expect.fulfill()
    } onError: { (err) in }
    waitForExpectations(timeout: 5, handler: .none)
  }

}
