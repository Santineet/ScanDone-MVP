import Foundation

@objc(FolderItem)
open class FolderItem: _FolderItem {
	// Custom logic goes here.
    
    static var saveQuality: CGFloat = 0.7

    var filePaths: [Path] {
        return filePaths(type: .edited)
    }
    
    func filePaths(type: FileItemFolderType) -> [Path] {
        return files.map({ $0.filePath(type) })
    }
    
    var count: Int {
        return files.count
    }
    
    var files: [FileItem] {
        let files = FileItem.mr_find(byAttribute: FileItemAttributes.folderId.rawValue, withValue: id) as! [FileItem]
        return files.sorted(by: { $0.order!.intValue < $1.order!.intValue })
    }
    
    var previewUrl: URL? {
        if let url = filePaths.first?.url {
            return url
        }
        return nil
    }
    
    var fileNames: [Int] {
        return files.map({ Int($0.id)! })
    }
    
    var path: Path {
        return FolderItem.path(id: id)
    }
    
    static func path(id: String) -> Path { return pathRoot + id }
    static let pathRoot = Path.userDocuments + "Content"
    static let pathTemp = Path.userDocuments + "Temp"

    static let dateFormatter: DateFormatter = {
        let item = DateFormatter()
        item.dateFormat = "MMM d - HH:mm"
        return item
    }()
    
    static var defaultName: String {
        return dateFormatter.string(from: Date()).uppercased()
    }
}


extension FolderItem {
    
    static func by(id: String) -> FolderItem? {
        return FolderItem.mr_findFirst(byAttribute: FolderItemAttributes.id.rawValue, withValue: id)
    }
    
    static func clearTemp() {
        do {
            try pathTemp.createDirectory()
        } catch (let error1) {
            print(error1)
        }
    }
    
    static func availableFileNames(_ folderItem: FolderItem?, _ count: Int) -> [Int] {
        guard let folderItem = folderItem, folderItem.count > 0 else {
            return Array(0..<count)
        }
        
        let max = folderItem.fileNames.max()
        if let max = max {
            var items = [Int]()
            for i in 1...count {
                items.append(max+i)
            }
            return items
        }
        return [0]
    }
    
    static func create(_ items: [ImportItem], _ savedFolder: FolderItem? = nil, completion: @escaping ((_ error : Error?) -> Void)) {
        
        let folderItem: FolderItem
        
        if let savedFolder = savedFolder {
            folderItem = savedFolder
        } else {
            folderItem = FolderItem.mr_createEntity()!
            folderItem.id = String.createIdFromTodayDate()
            folderItem.name = FolderItem.defaultName
            NSManagedObjectContext.save()
        }
        
        let id = folderItem.id
        let availableFileNames = FolderItem.availableFileNames(savedFolder, items.count)
        
        let folderPath = folderItem.path
        let originalFolderPath = folderPath + FileItemFolderType.original.path
        let editedFolderPath = folderPath + FileItemFolderType.edited.path

        do {
            if !folderPath.exists {
                try folderPath.createDirectory()
            }
            if !originalFolderPath.exists {
                try originalFolderPath.createDirectory()
            }
            if !editedFolderPath.exists {
                try editedFolderPath.createDirectory()
            }
        } catch (let error1) {
            print(error1)
        }
        
        var error: Error?
        for (index,i) in items.enumerated() {
            guard index >= 0, index < availableFileNames.count, availableFileNames.count > 0 else {
                completion(nil)
                return
            }
            
            let fileName = availableFileNames[index]
            let fileNameFull = String(fileName) + FileItem.fileExtension
            let pathOriginal = originalFolderPath + fileNameFull
            let pathEdit = editedFolderPath + fileNameFull
    
            let fileItem = FileItem.mr_createEntity()!
            fileItem.id = String(fileName)
            fileItem.filter = i.filter
            fileItem.order = fileName as NSNumber
            fileItem.folderId = id
            fileItem.angle = i.angle
            fileItem.quad = i.quad
            fileItem.originalQuad = i.originalQuad
            NSManagedObjectContext.save()

            do {
                try i.original.fixedOrientation().write(to: pathOriginal)
                try i.display.fixedOrientation().write(to: pathEdit)
            } catch (let error1) {
                print(error1)
                error = error1
            }
            fileItem.clearCache()
        }
        
        completion(error)
    }
    
    static func update(_ items: [ImportItem], _ savedFolder: FolderItem, completion: @escaping ((_ error : Error?) -> Void)) {
        
        var filesToDelete = [FileItem]()
        for i in savedFolder.files {
            if let _ = items.filter({ $0.item?.id == i.id }).first {
            } else {
                filesToDelete.append(i)
            }
        }
        
        var itemsToUpdate = [ImportItem]()
        var itemsToCreate = [ImportItem]()
        
        for i in items {
            i.item == nil ? itemsToCreate.append(i) : itemsToUpdate.append(i)
        }
        
        for i in itemsToUpdate {
            guard let item = i.item else { continue }
            item.filter = i.filter
            item.angle = i.angle
            item.quad = i.quad
            item.originalQuad = i.originalQuad
            NSManagedObjectContext.save()
            item.clearCache()

            var error: Error?
            do {
                try i.display.fixedOrientation().write(to: item.filePath(.edited))
            } catch (let error1) {
                print(error1)
                error = error1
            }
        }
        
        if itemsToCreate.isEmpty {
            if filesToDelete.isEmpty {
                completion(nil)
            } else {
                savedFolder.deleteFiles(filesToDelete) { (error) in
                    completion(error)
                }
            }
        } else {
            create(itemsToCreate, savedFolder) { (error) in
                if filesToDelete.isEmpty {
                    completion(error)
                } else {
                    savedFolder.deleteFiles(filesToDelete) { (error) in
                        completion(error)
                    }
                }
            }
        }
        
        
    }
    
    func delete(_ completion: @escaping ((_ error : Error?) -> Void)) {
        var error: Error?
        do {
            try path.deleteFile()
        } catch (let error1) {
            print(error1)
            error = error1
        }
        
        for i in files {
            i.clearCache()
            i.mr_deleteEntity()
        }
        mr_deleteEntity()
        NSManagedObjectContext.save()
        
        completion(error)
    }
    
    
    func deleteFiles(_ files: [FileItem], _ completion: @escaping ((_ error : Error?) -> Void)) {
        var error: Error?
        do {
            for i in files {
                try i.filePath(.edited).deleteFile()
                try i.filePath(.original).deleteFile()
            }
        } catch (let error1) {
            print(error1)
            error = error1
        }
        
        for i in files {
            i.clearCache()
            i.mr_deleteEntity()
        }
        NSManagedObjectContext.save()
        
        completion(error)
    }
    
    static func reoder(_ FolderItem: FolderItem, _ index1: Int, _ index2: Int) {
        guard index1 >= 0, index2 >= 0, index1 != index2, index1 < FolderItem.count, index2 < FolderItem.count else {
            return
        }
        let item1 = FolderItem.files[index1]
        let item2 = FolderItem.files[index2]
        let temp = item1.order
        item1.order = item2.order
        item2.order = temp
        NSManagedObjectContext.save()
    }
}

extension FolderItem {
    
    public static func == (lhs: FolderItem, rhs: FolderItem) -> Bool {
        return lhs.id == rhs.id
    }
}
