//
//  FileHelper.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 13/2/2565 BE.
//

import Foundation


enum FileCategory: String {
    case local = "FileLocal"
    case other = ""
}

class FileHelper: NSObject {
    
    static func getFile(fileName: String, category: FileCategory) -> Data? {
        let fileManager = FileManager.default
        if let fileURL = self.getFilePath(fileName: fileName, category: category) {
           
            let data = fileManager.contents(atPath: fileURL.path)
            return data
            
        }
        
        return nil
    }
    
    static func getFileURL(urlString: String, category: FileCategory) -> URL? {
        let fileManager = FileManager.default
        if let fileDirectory = self.getDirectory(category: category) {
            do {
                let fileArray = try fileManager.contentsOfDirectory(at: fileDirectory, includingPropertiesForKeys: nil, options: [])
                return fileArray.filter({ (url) -> Bool in
                    return url.absoluteURL.absoluteString == urlString
                }).first
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    static func getListFile(category: FileCategory) -> [URL] {
        let fileManager = FileManager.default
        if let fileDirectory = self.getDirectory(category: category) {
            do {
                return try fileManager.contentsOfDirectory(at: fileDirectory, includingPropertiesForKeys: nil, options: [])
            } catch {
                return [URL]()
            }
        }
        
        return [URL]()
    }
    
    static func saveFile(fileName: String, subDirectory: String?, data: Data, category: FileCategory) -> URL? {
        if let fileDirectory = self.getDirectory(category: category, subDirectory: subDirectory) {
            let newFileURL = fileDirectory.appendingPathComponent(fileName)
            
            // remove old file
            _ = self.removeFile(url: newFileURL)
        
            do {
                try data.write(to: newFileURL)
                return newFileURL
            } catch {
                print(error.localizedDescription)
                print("Error File : Cannot write file to url \(newFileURL.absoluteString)")
            }
        }
        
        return nil
    }
    
    static func saveFileFromTemp(fileName: String, subDirectory: String?, tempURL: URL, category: FileCategory) -> URL? {
        let fileManager = FileManager.default
        if let fileDirectory = self.getDirectory(category: category, subDirectory: subDirectory) {
            do {
                var newFileURL: URL!
                if subDirectory != nil {
                    newFileURL = fileDirectory.appendingPathComponent(subDirectory!, isDirectory: true).appendingPathComponent(fileName)
                } else {
                    newFileURL = fileDirectory.appendingPathComponent(fileName)
                }
                
                // remove old file
                _ = self.removeFile(url: newFileURL)
                
                try fileManager.moveItem(at: tempURL, to: newFileURL)
                return newFileURL
            } catch {
                print(error.localizedDescription)
                print("Error File : Cannot move file from temp \(tempURL.absoluteString)")
                return nil
            }
            
        }
        
        return nil
    }
    
    static func saveFileFromTemp(tempURL: URL, category: FileCategory) -> URL? {
        let fileManager = FileManager.default
        if let fileDirectory = self.getDirectory(category: category, subDirectory: nil) {
            do {
                let newFileURL = fileDirectory.appendingPathComponent(tempURL.lastPathComponent)
                
                // remove old file
                _ = self.removeFile(url: newFileURL)
                
                try fileManager.moveItem(at: tempURL, to: newFileURL)
                return newFileURL
            } catch {
                print(error.localizedDescription)
                print("Error File : Cannot move file from temp \(tempURL.absoluteString)")
                return nil
            }
            
        }
        
        return nil
    }
    
    static func removeFile(urlString: String, category: FileCategory) -> Bool {
        var isSuccess = false
        let fileManager = FileManager.default
        if let fileRemove = self.getFileURL(urlString: urlString, category: category) {
            do {
                try fileManager.removeItem(at: fileRemove)
                isSuccess = true
            } catch {
                print(error.localizedDescription)
                print("Error File : Cannot remove file \(fileRemove.absoluteString)")
            }
        }
        
        return isSuccess
    }
    
    static func removeFile(url: URL) -> Bool {
        var isSuccess = false
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            isSuccess = true
        } catch {
            print("Error File : Cannot remove file \(url.absoluteString)")
        }
        
        return isSuccess
    }
    
    static func removeAllFile() {
        
        // local
        _ = self.removeAllFile(category: .local)
        
        // other
        _ = self.removeAllFile(category: .other)
    }
    
    static func getMimeTypeFromFileExtension(fileExtension: String) -> String {
        var mimeType = ""
        
        switch fileExtension.lowercased() {
        case "docx":
            mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            break
        case "doc":
            mimeType = "application/msword"
            break
        case "xlsx":
            mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            break
        case "xls":
            mimeType = "application/vnd.ms-excel"
            break
        case "pptx":
            mimeType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            break
        case "ppt":
            mimeType = "application/vnd.ms-powerpoint"
            break
        case "pdf":
            mimeType = "application/pdf"
            break
        case "jpeg", "jpg":
            mimeType = "image/jpeg"
            break
        case "png":
            mimeType = "image/png"
            break
        case "txt":
            mimeType = "text/plain"
            break
        default:
            break
        }
        
        return mimeType
    }
    
    // MARK: - Private Method
    private static func getFilePath(fileName:String , category: FileCategory, subDirectory: String? = nil) -> URL? {
        if let directoryPath = self.getDirectory(category: category, subDirectory: subDirectory) {
            let url = directoryPath.appendingPathComponent(fileName)
            return url
        }
        else
        {
            return nil
        }
    }
    private static func getDirectory(category: FileCategory, subDirectory: String? = nil) -> URL? {
        let fileManager = FileManager.default
        // Get Path
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            var directory = documentDirectory.appendingPathComponent(category.rawValue)
            
            var isDirectory = ObjCBool(true)
            let exists = FileManager.default.fileExists(atPath: directory.absoluteString, isDirectory: &isDirectory)
            
            
            if exists && isDirectory.boolValue {
            
            }
            else{
                do {
                    try fileManager.createDirectory(at: directory, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print("document cannot create \(error.localizedDescription)")
                }
            }
            
            if subDirectory != nil {
                directory = directory.appendingPathComponent(subDirectory!)
                do {
                    try fileManager.createDirectory(at: directory, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }

            return directory
            
        } catch {
            return nil
        }
    }
    
    private static func removeAllFile(category: FileCategory) -> Bool {
        var isSuccess = false
        let fileManager = FileManager.default
        
        let listFileDownload = self.getListFile(category: category)
        for file in listFileDownload {
            do {
                try fileManager.removeItem(at: file)
                isSuccess = true
            } catch {
                print("Error File : Cannot remove file \(file.absoluteString)")
            }
        }
        return isSuccess
    }
}
