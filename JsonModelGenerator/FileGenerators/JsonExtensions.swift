// JsonExtensions.swift

// Do not add multiple copies of this generated file to your project
// Generated 2017-01-20 03:34:35 +0000
import Foundation

public protocol JsonModel {
    init?(dictionary:[String: Any?]?)
    var jsonDictionary: [String: Any?] { get }
}

public extension JsonModel {
    public init?(json: String) {
        self.init(dictionary:json.jsonDict)
    }

    public func serializeDictionary(dictionary: [String:Any?]) -> String? {
        do {
            let x = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: x, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    public var jsonString: String? {
        return serializeDictionary(dictionary: jsonDictionary)
    }

}

public extension String {
    var jsonDict: [String: Any] {
        do {
            guard let data = data(using: .utf8, allowLossyConversion: true) else { return [:] }
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else { return [:] }
            return dict
        } catch {
            return [:]
        }
    }
}

class CustomPropertyFactory {
    
    class func getJsonDictionary(for thing: Any?) -> Any? {
        if let jsonModel = thing as? JsonModel {
            return jsonModel.jsonDictionary
        } else if let objectArray = thing as? [Any] {
            var output = [Any]()
            for object in objectArray {
                if let objectDict = getJsonDictionary(for: object) {
                    output.append(objectDict)
                }
            }
            return output
        }
        return thing
    }
    
    class func getObject<T: JsonModel>(type: T.Type, from: Any?, factory: ([String: Any?])->(T?)) -> Any? {
        if let dictionary = from as? [String: Any?] {
            return factory(dictionary)
        } else if let thingArray = from as? [Any] {
            var outputArray = [Any]()
            for item in thingArray {
                if let object = getObject(type: type, from: item, factory: factory) {
                    outputArray.append(object)
                }
            }
            return outputArray
        }
        return nil
    }
    
}

