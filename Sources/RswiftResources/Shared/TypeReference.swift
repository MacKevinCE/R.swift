//
//  TypeReference.swift
//  R.swift
//
//  Created by Mathijs Kadijk on 10-12-15.
//

import Foundation

public struct TypeReference: Hashable {
    public let module: ModuleReference
    public let name: String
    public var genericArgs: [TypeReference]
    public let optional: Bool

    public init(module: ModuleReference, rawName: String, optional: Bool = false) {
        self.module = module
        self.name = rawName
        self.genericArgs = []
        self.optional = optional
    }

    public init(module: ModuleReference, name: String, genericArgs: [TypeReference], optional: Bool = false) {
        self.module = module
        self.name = name
        self.genericArgs = genericArgs
        self.optional = optional
    }

    public var allModuleReferences: Set<ModuleReference> {
        Set(genericArgs.flatMap(\.allModuleReferences)).union([module])
    }
}
