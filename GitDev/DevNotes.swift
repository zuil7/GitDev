//
//  DevNotes+CoreDataClass.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//
//

import Foundation
import CoreData

// MARK: - Devnotes Entity

@objc(DevNotes)
public class DevNotes: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DevNotes> {
      return NSFetchRequest<DevNotes>(entityName: "DevNotes")
  }

  @NSManaged public var id: Int32
  @NSManaged public var notes: String?
}
