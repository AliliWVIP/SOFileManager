import Foundation

public enum SOFileManagerDirectoryType {
    case documents
    case temp
    case cache
    case home
}

public class SOFileManager {
    
    
}
extension SOFileManager {
    /**
        获取沙盒目录
     @param directoryType 沙盒目录类型
     @return String 对应路径
     */
    public static func getDirectory(directoryType: SOFileManagerDirectoryType) -> String {
        switch directoryType {
        case .documents:
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        case .temp:
            return NSTemporaryDirectory()
        case .cache:
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        case .home:
            return NSHomeDirectory()
        }
    }
    /**
     同步存储数据到本地
     @param path 文件路径
     @param data 需要存储的数据
     @return Bool 是否保存成功
     */
    public static func saveData(data: Data, path: String) -> Bool{
        guard  ((try? data.write(to: URL(fileURLWithPath: path), options: .atomic)) != nil) else {
            return false
        }
        return true
    }
    /**
     异步存储数据到本地
     @param path 文件路径
     @param data 需要存储的数据
     @param callback 存储完成后回调
     @return Bool 是否保存成功
     */
    public static func asyncSaveData(data: Data, path: String, callback:@escaping (_ isSuccess: Bool) -> Void) {
        let queue = DispatchQueue(label: "SO.FileManager")
        queue.async {
            callback(self.saveData(data: data, path: path))
        }
    }
    /**
     加载文件
     @param path 文件路径
     @return callback 文件中的数据
     */
    public static func loadData(from path: String, callback:@escaping (_ isSuccess: Bool,_ data: Data) -> Void){
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            callback(false, Data())
            return
        }
        callback(true, data)
    }
    /**
     加载文件
     @param path 文件路径
     @return callback 文件中的数据
     */
    public static func asyncLoadData(path: String, callback:@escaping (_ isSuccess: Bool, _ data: Data) -> Void) {
        let queue = DispatchQueue(label: "SO.FileManager")
        queue.async {
            loadData(from: path, callback: callback)
        }
    }
    /**
     移除文件
     @param path 文件路径
     */
    public static func removeFile(path: String) -> Bool {
        let fileManager = FileManager.default
        if path.count > 0 {
            guard (try? fileManager.removeItem(at: URL(fileURLWithPath: path))) != nil else {
                return false
            }
        }
        return true
    }
    
    /**
     清空文件夹
     @param path 文件夹路径
     */
    public static func clearFile(path: String) -> Bool {
        let fileManager = FileManager.default
        let subPaths: [String] = fileManager.subpaths(atPath: path) ?? [String]()
        for subPath in subPaths {
            let fullPath = "\(path)/\(subPath)"
            _ = removeFile(path: fullPath)
        }
        return true
    }
    
    /**
     按条件移除文件
     */
    public static func removeFileAt(path: String, condition:@escaping (_ fileInfo: Dictionary<FileAttributeKey, Any>) -> Bool){
        let fileManager = FileManager.default
        let enumerate: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path) ?? FileManager.DirectoryEnumerator()
        for fileName in enumerate {
            let filePath = "\(path)/\(fileName)"
            let fileInfo = try! fileManager.attributesOfItem(atPath: filePath)
            if condition(fileInfo) {
                try? fileManager.removeItem(at: URL(fileURLWithPath: filePath))
            }
        }
    }
    
    

}

