//
//  WPBase.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

public struct WPPOP<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol WPPOPCompatible {}

public extension WPPOPCompatible {
    static var wp: WPPOP<Self>.Type {
        get{ WPPOP<Self>.self }
        set {}
    }
    
    var wp: WPPOP<Self> {
        get { WPPOP(self) }
        set {}
    }
}

/// Define Property protocol
internal protocol WPSwiftPropertyCompatible {
  
    /// Extended type
    associatedtype T
    
    ///Alias for callback function
    typealias SwiftCallBack = ((T?) -> ())
    
    ///Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack?  { get set }
}

public func wp_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

public func wp_setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T, _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, key, value, policy)
}
