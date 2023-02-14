//
//  FontResource+Generator.swift
//  rswift
//
//  Created by Tom Lokhorst on 2021-04-18.
//

import Foundation
import RswiftResources

extension FontResource {
    public static func generateStruct(resources: [FontResource], prefix: SwiftIdentifier) -> Struct {
        let structName = SwiftIdentifier(name: "font")
        let qualifiedName = prefix + structName
        let warning: (String) -> Void = { print("warning: [R.swift]", $0) }

        let groupedResources = resources.grouped(bySwiftIdentifier: { $0.name })
        groupedResources.reportWarningsForDuplicatesAndEmpties(source: "font resource", result: "font", warning: warning)

        let vargetters = groupedResources.uniques.map { $0.generateVarGetter() }

        let comments = ["This `\(qualifiedName.value)` struct is generated, and contains static references to \(vargetters.count) fonts."]

        return Struct(comments: comments, name: structName, protocols: [.sequence]) {
            Init.bundle
            if vargetters.count > 0 {
                generateMakeIterator(names: vargetters.map(\.name))
                generateValidate()
            }
            vargetters
        }
    }

    private static func generateMakeIterator(names: [SwiftIdentifier]) -> Function {
        Function(
            comments: [],
            name: .init(name: "makeIterator"),
            params: [],
            returnType: .indexingIterator(.fontResource),
            valueCodeString: "[\(names.map(\.value).joined(separator: ", "))].makeIterator()"
        )
    }

    private static func generateValidate() -> Function {
        Function(
            comments: [],
            name: .init(name: "validate"),
            params: [],
            returnThrows: true,
            returnType: .void,
            valueCodeString: #"""
            for font in self {
              if !font.canBeLoaded() { throw RswiftResources.ValidationError("[R.swift] Font '\(font.name)' could not be loaded, is '\(font.filename)' added to the UIAppFonts array in this targets Info.plist?") }
            }
            """#
        )
    }
}

extension FontResource {
    func generateVarGetter() -> VarGetter {
        SLVF.shared.append(contentsOf: generateStatic())
        return VarGetter(
            comments: ["Font `\(name)`."],
            name: SwiftIdentifier(name: name),
            typeReference: TypeReference(module: .rswiftResources, rawName: "FontResource"),
            valueCodeString: ".init(name: \"\(name)\", bundle: bundle, filename: \"\(filename)\")"
        )
    }

    func generateStatic() -> [SLVF] {
        let namePathResource = SwiftIdentifier(name: name).value
        let letSize = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 72, 80].map { size in
            let code = "\(namePathResource)(size: \(size))"
            return SLVF(
                comments: ["Font `\(name) size: \(size)`."],
                name: SwiftIdentifier(name: "\(name)\(size)"),
                fileReference: .uiFont,
                valueCodeString: code
            )
        }

        let code = "R.font.\(namePathResource).callAsFunction(size: size)!"
        let funcSize = SLVF(
            comments: ["Font `\(name)`."],
            name: SwiftIdentifier(name: name),
            parameters: [Function.Parameter(name: "size", localName: nil, typeReference: .cgFloat, defaultValue: nil)],
            fileReference: .uiFont,
            typeReference: .uiFont,
            valueCodeString: code
        )

        return [[funcSize], letSize].flatMap { $0 }
    }
}
