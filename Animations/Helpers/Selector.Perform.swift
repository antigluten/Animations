//
//  Selector.Perform.swift
//  Animations
//
//  Created by Vladimir Gusev on 23.07.2022.
//

import Foundation

public extension Selector {
    /// Wraps a closure in a `Selector`.
    /// - Note: Callable as a function.
    final class Perform: NSObject {
        
        private let perform: () -> Void
        
        public init(_ perform: @escaping () -> Void) {
            self.perform = perform
            super.init()
        }
        
    }
}

//MARK: Public
public extension Selector.Perform {
    @objc func callAsFunction() { perform() }
    var selector: Selector { #selector(callAsFunction) }
}
