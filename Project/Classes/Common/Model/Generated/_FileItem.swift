// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FileItem.swift instead.

import Foundation
import CoreData

public enum FileItemAttributes: String {
    case angleRaw = "angleRaw"
    case filterRaw = "filterRaw"
    case folderId = "folderId"
    case id = "id"
    case order = "order"
    case originalQuadRaw = "originalQuadRaw"
    case quadRaw = "quadRaw"
}

open class _FileItem: NSManagedObject {

    // MARK: - Class methods

    @objc open class func entityName () -> String {
        return "FileItem"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _FileItem.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var angleRaw: NSNumber?

    @NSManaged open
    var filterRaw: NSNumber?

    @NSManaged open
    var folderId: String

    @NSManaged open
    var id: String

    @NSManaged open
    var order: NSNumber?

    @NSManaged open
    var originalQuadRaw: AnyObject?

    @NSManaged open
    var quadRaw: AnyObject?

    // MARK: - Relationships

}

