//
//  File.swift
//  
//
//  Created by Tom Lokhorst on 2022-07-24.
//

import Foundation
import RswiftResources

extension TypeReference {
    func codeString() -> String {
        let args = genericArgs.map { $0.codeString() }.joined(separator: ", ")
        let rawName = args.isEmpty ? name : "\(name)<\(args)>"
        let rawOptional = optional ? "\(rawName)?" : rawName
        
        if case .custom(let module) = module {
            return "\(module).\(rawOptional)"
        } else {
            return rawOptional
        }
    }

//    static func someIteratorProtocol(_ element: TypeReference) -> TypeReference {
//        var result = TypeReference(module: .stdLib, rawName: "some IteratorProtocol")
//        result.genericArgs = [element]
//        return result
//    }

    static func indexingIterator(_ element: TypeReference) -> TypeReference {
        var result = TypeReference(module: .stdLib, rawName: "IndexingIterator")
        result.genericArgs = [TypeReference(module: .stdLib, rawName: "[\(element.codeString())]")]
        return result
    }

    static var bundle: TypeReference = .init(module: .foundation, rawName: "Bundle")
    static var locale: TypeReference = .init(module: .foundation, rawName: "Locale")
    static var void: TypeReference = .init(module: .stdLib, rawName: "Void")
    static var bool: TypeReference = .init(module: .stdLib, rawName: "Bool")
    static var string: TypeReference = .init(module: .stdLib, rawName: "String")
    static var sequence: TypeReference = .init(module: .stdLib, rawName: "Sequence")
    static var someIteratorProtocol: TypeReference = .init(module: .stdLib, rawName: "some IteratorProtocol")
    static var uiView: TypeReference = .init(module: .uiKit, rawName: "UIView")
    static var uiViewController: TypeReference = .init(module: .uiKit, rawName: "UIViewController")
    static var nsViewController: TypeReference = .init(module: .appKit, rawName: "NSViewController")
    static var cgFloat: TypeReference = .init(module: .stdLib, rawName: "CGFloat")
    static var uiColor: TypeReference = .init(module: .uiKit, rawName: "UIColor")
    static var uiFont: TypeReference = .init(module: .uiKit, rawName: "UIFont")
    static var uiImage: TypeReference = .init(module: .uiKit, rawName: "UIImage")
    static var uiNib: TypeReference = .init(module: .uiKit, rawName: "UINib")
    static var uiStoryboardSegue: TypeReference = .init(module: .uiKit, rawName: "UIStoryboardSegue")
    static var nsDataAsset: TypeReference = .init(module: .uiKit, rawName: "NSDataAsset")
    static var url: TypeReference = .init(module: .foundation, rawName: "URL")

    static var fontResource: TypeReference = .init(module: .rswiftResources, rawName: "FontResource")
}
