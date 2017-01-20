//
//  JsonExtensionsGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

class JsonExtensionsGenerator {
    
    private var fileLocation: String
    
    init(fileLocation: String) {
        self.fileLocation = fileLocation
    }
    
    func buildSupportFile() throws {
        let fileContents = "// JsonExtensions.swift\n" +
            "// Generated by SwiftJsonGenerator: https://github.com/charles-oder/SwiftJsonGenerator\n" +
            "// Do not add multiple copies of this generated file to your project\n" +
            "// Generated \(Date().description)\n" +
            "import Foundation\n" +
            "\n" +
            "public protocol JsonModel {\n" +
            "    init?(dict:[String: Any?]?)\n" +
            "    var jsonDictionary: [String: Any?] { get }\n" +
            "}\n" +
            "\n" +
            "public extension JsonModel {\n" +
            "    public init?(json: String) {\n" +
            "        self.init(dict:json.jsonDict)\n" +
            "    }\n" +
            "\n" +
            "    public func serializeDictionary(dict: [String:Any?]) -> String? {\n" +
            "        do {\n" +
            "            let x = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))\n" +
            "            return String(data: x, encoding: .utf8)\n" +
            "        } catch {\n" +
            "            return nil\n" +
            "        }\n" +
            "    }\n" +
            "    \n" +
            "    public var jsonString: String? {\n" +
            "        return serializeDictionary(dict: jsonDictionary)\n" +
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
            "}"
        let fileName = "JsonExtensions.swift"
        try write(body: fileContents, toFile: fileName)
    }
    
    private func write(body: String, toFile: String) throws {
        let url = URL(fileURLWithPath: fileLocation + toFile)
        try body.data(using: .utf8, allowLossyConversion: true)?.write(to: url)
    }
}