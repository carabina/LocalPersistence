

import Foundation

/// eunum that describes all possible errors thrown in LocalStorage class
enum StorageError: Error {
    case failedToWrite
    case failedToReadFile
    case failedToDecode
}


/**
 LocalStorage is class that can persist any object that conforms to the Codable Protocol
 by Storing the instance recieved in json files stored in the documents Directory
 */
class LocalStorage {
    
    ///only instance of this class
    static let instance = LocalStorage()
    
    private let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    private init(){}
    
    private func getURLInDocumentDir(for file: String) -> URL {
        return URL(fileURLWithPath: self.documentDir.appendingPathComponent(file + ".json"))
    }
    
    /**
     Saves a given Codable object into a file with given name
     
     - parameters:
     - data: codable instance to be saved
     - file: string with file name
     without extension
     
     
     - throws:
     .failedToEncode error of Type StorageError
     */
    
    func save<T:Codable>(data: T, in file: String) throws{
        
        let url = getURLInDocumentDir(for: file)
        
        
        let data1 = try JSONEncoder().encode(data)
        
        do{
            try data1.write(to: url)
        }catch{
            throw StorageError.failedToWrite
        }
    }
    
    /**
     loads information stored into file with given name into given object
     
     - parameters:
     - object: codable object that will be overriten with contents of given file
     - file: string with file name
     
     - important:
     make sure object given is the same type as object stored in file
     object given is overriten
     
     - throws:
     .cantReadFile error of type StorageError
     .failedTODecode error of type StorageError
     */
    func load<T:Codable>(into object: inout T, in file: String) throws{
        let url = getURLInDocumentDir(for: file)
        var readedData:Data!
        do {
            readedData = try Data(contentsOf: url)
        } catch  {
            throw StorageError.failedToReadFile
        }
        do {
            object = try JSONDecoder().decode(T.self, from: readedData)
        } catch {
            print("could not override object , make sure object given is the same type as object stored in file")
            throw StorageError.failedToDecode
        }
    }
    
}

