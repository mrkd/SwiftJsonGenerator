//
//  JsonExtensionsGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

class JsonExtensionsGenerator: FileGenerator {
    
    func buildSupportFile() throws {
        let fileContents = "// JsonExtensions.swift\n" +
            "// Generated by SwiftJsonGenerator: https://github.com/charles-oder/SwiftJsonGenerator\n" +
            "// Do not add multiple copies of this generated file to your project\n" +
            "// Generated \(Date().description)\n" +
            "import Foundation\n" +
            "\n" +
            "public protocol JsonModel {\n" +
            "    init?(dictionary:[String: Any?]?)\n" +
            "    var jsonDictionary: [String: Any?] { get }\n" +
            "}\n" +
            "\n" +
            "public extension JsonModel {\n" +
            "    public init?(json: String) {\n" +
            "        self.init(dictionary:json.jsonDict)\n" +
            "    }\n" +
            "\n" +
            "    public func serializeDictionary(dictionary: [String:Any?]) -> String? {\n" +
            "        do {\n" +
            "            let x = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))\n" +
            "            return String(data: x, encoding: .utf8)\n" +
            "        } catch {\n" +
            "            return nil\n" +
            "        }\n" +
            "    }\n" +
            "    \n" +
            "    public var jsonString: String? {\n" +
            "        return serializeDictionary(dictionary: jsonDictionary)\n" +
            "    }\n" +
            "\n" +
            "}\n" +
            "\n" +
            "public extension String {\n" +
            "    var jsonDict: [String: Any] {\n" +
            "        do {\n" +
            "            guard let data = data(using: .utf8, allowLossyConversion: true) else { return [:] }\n" +
            "            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else { return [:] }\n" +
            "            return dict\n" +
            "        } catch {\n" +
            "            return [:]\n" +
            "        }\n" +
            "    }\n" +
            "}\n\n" +
            "class CustomPropertyFactory {\n" +
            "\n" +
            "    class func getJsonDictionary(for thing: Any?) -> Any? {\n" +
            "        if let jsonModel = thing as? JsonModel {\n" +
            "            return jsonModel.jsonDictionary\n" +
            "        } else if let objectArray = thing as? [Any] {\n" +
            "            var output = [Any]()\n" +
            "            for object in objectArray {\n" +
            "                if let objectDict = getJsonDictionary(for: object) {\n" +
            "                    output.append(objectDict)\n" +
            "                }\n" +
            "            }\n" +
            "            return output\n" +
            "        }\n" +
            "        return thing\n" +
            "    }\n" +
            "\n" +
            "    class func getObject<T: JsonModel>(type: T.Type, from: Any?, factory: ([String: Any?])->(T?)) -> Any? {\n" +
            "        if let dictionary = from as? [String: Any?] {\n" +
            "            return factory(dictionary)\n" +
            "        } else if let thingArray = from as? [Any] {\n" +
            "            var outputArray = [Any]()\n" +
            "            for item in thingArray {\n" +
            "                if let object = getObject(type: type, from: item, factory: factory) {\n" +
            "                    outputArray.append(object)\n" +
            "                }\n" +
            "            }\n" +
            "            return outputArray\n" +
            "        }\n" +
            "        return nil\n" +
            "    }\n" +
            "\n" +
            "}\n"
        

        let fileName = "JsonExtensions.swift"
        try write(body: fileContents, toFile: fileName)
    }
    
}
