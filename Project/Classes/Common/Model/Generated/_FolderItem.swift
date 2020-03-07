// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FolderItem.swift instead.

import Foundation
import CoreData

public enum FolderItemAttributes: String {
    case id = "id"
    case name = "name"
}

open class _FolderItem: NSManagedObject {

    // MARK: - Class methods

    @objc open class func entityName () -> String {
        return "FolderItem"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FolderItem.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var id: String

    @NSManaged open
    var name: String

    // MARK: - Relationships

}

