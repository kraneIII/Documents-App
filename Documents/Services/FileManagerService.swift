import Foundation
import UIKit

class FileManagerService: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    var url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var item: [URL] {
        (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [])) ?? []
    }
    
    func urls() -> [URL] {
         var urls: [URL] = []
         
         do {
             let documentaryUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
             let content = try FileManager.default.contentsOfDirectory(at: documentaryUrl, includingPropertiesForKeys: nil, options: [])
             urls = content
         } catch {
             print(error.localizedDescription)
         }
         return urls
     }
    
    func files() -> [String] {
        var files: [String] = []
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: documentsUrl.path)
            files = allFiles
        } catch {
            print(error.localizedDescription)
        }
        
        if userDefaults.bool(forKey: "settings") {
                   return files.sorted(by: <)
               }
               return files.sorted(by: >)
    }
    
    func createFolder(name: String) {
        try? FileManager.default.createDirectory(at: url.appending(path: name), withIntermediateDirectories: true)
    }
    
    func createFile(photo: UIImage, content: String?) {
         let documentsUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let photoPath = documentsUrl?.appendingPathComponent(content ?? "", conformingTo: .png)
        if let image = photo.jpegData(compressionQuality: 1) {
            FileManager.default.createFile(atPath: photoPath!.path, contents: image)
        }
    }
    
    func deleteFile(atIndex index: Int) {
        try? FileManager.default.removeItem(atPath: item[index].path())
    }
    
    func isFolder(atIndex index: Int) -> Bool {
        var isFolder: ObjCBool = false
        FileManager.default.fileExists(atPath: item[index].path(), isDirectory: &isFolder)
        
        return isFolder.boolValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func catchImage(fileName: String) -> UIImage {
         var finalImage: UIImage = UIImage()
         
         do {
             let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
             let imagePath = documentsUrl.appending(component: fileName)
             if FileManager.default.fileExists(atPath: imagePath.path) {
                 let data = try Data(contentsOf: imagePath)
                 guard  let image = UIImage(data: data) else {return UIImage()}
                 finalImage = image
             }
         } catch {
             print(error.localizedDescription)
         }
         
         return finalImage
     }


}

