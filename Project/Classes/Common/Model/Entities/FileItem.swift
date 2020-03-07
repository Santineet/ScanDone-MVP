import Foundation

@objc(FileItem)
open class FileItem: _FileItem {
	// Custom logic goes here.
    
    static let fileExtension = ".jpg"

    static func fileNameFromPath(_ path: Path) -> Int {
        let fileName = (path.fileName as NSString).replacingOccurrences(of: FileItem.fileExtension, with: "")
        return Int(fileName as String) ?? 0
    }
    
    var fileName: String {
        return id
    }
    
    var filter: FilterItem {
        get {
            return FilterItem(rawValue: filterRaw!.intValue)!
        } set {
            filterRaw = newValue.rawValue as NSNumber
        }
    }
    
    var angle: Int {
        get {
            return angleRaw?.intValue ?? 0
        } set {
            angleRaw = newValue as NSNumber
        }
    }
    
    var quad: Quadrilateral? {
        get {
            return Quadrilateral.fromCoreData(quadRaw)
        } set {
            quadRaw = Quadrilateral.toCoreData(newValue)
        }
    }
    
    var originalQuad: Quadrilateral? {
        get {
            return Quadrilateral.fromCoreData(originalQuadRaw)
        } set {
            originalQuadRaw = Quadrilateral.toCoreData(newValue)
        }
    }
    
    var path: Path {
        return filePath(.edited)
    }
    
    func filePath(_ type: FileItemFolderType) -> Path {
        return folderPath(type) + String(id + FileItem.fileExtension)
    }
    
    func folderPath(_ type: FileItemFolderType) -> Path {
        return FolderItem.path(id: folderId) + type.path
    }
    
    func clearCache() {
        SDImageCache.shared.removeImageFromDisk(forKey: path.url.absoluteString)
        SDImageCache.shared.removeImageFromMemory(forKey: path.url.absoluteString)
    }
    
    var file: UIImage? {
        return UIImage(contentsOfFile: path.rawValue)
    }

}


extension FileItem {

    static func moveCopy(type: MovePresenterType, items: [FileItem], _ folder: FolderItem, completion: @escaping ((_ error : Error?) -> Void)) {
        
        let availableFileNames = FolderItem.availableFileNames(folder, items.count)
        
        var error: Error?
        for (index,i) in items.enumerated() {
            guard index >= 0, index < availableFileNames.count, availableFileNames.count > 0 else {
                completion(nil)
                return
            }
            
            let pathOriginal = i.filePath(.original)
            let pathEdit = i.filePath(.edited)
            let fileName = availableFileNames[index]
            let fileItem: FileItem

            switch type {
            case .move:
                fileItem = i
                i.clearCache()
            case .copy:
                fileItem = FileItem.mr_createEntity()!
                fileItem.filter = i.filter
                fileItem.angle = i.angle
                fileItem.quad = i.quad
                fileItem.originalQuadRaw = i.originalQuadRaw
            }
            fileItem.id = String(fileName)
            fileItem.order = fileName as NSNumber
            fileItem.folderId = folder.id
            NSManagedObjectContext.save()
        
            i.clearCache()

            let pathOriginalNew = fileItem.filePath(.original)
            let pathEditedNew = fileItem.filePath(.edited)

            do {
                switch type {
                case .move:
                    try pathOriginal.moveFile(to: pathOriginalNew)
                    try pathEdit.moveFile(to: pathEditedNew)
                case .copy:
                    let imageOriginal = UIImage(url: i.filePath(.original).url)?.fixedOrientation()
                    let imageEdited = UIImage(url: i.filePath(.edited).url)?.fixedOrientation()
                    try imageOriginal?.write(to: pathOriginalNew)
                    try imageEdited?.write(to: pathEditedNew)
                }
            } catch (let error1) {
                print(error1)
                error = error1
            }
        }
        completion(error)
    }
}


enum FileItemFolderType {
    case original, edited
    
    var path: String {
        switch self {
        case .original: return "original"
        case .edited: return "edited"
        }
    }
}


