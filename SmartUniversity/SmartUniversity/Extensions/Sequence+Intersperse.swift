//
//  Sequence+Intersperse.swift
//  SmartUniversity
//
//  Created by Tomas Skypala on 05/07/2020.
//  Copyright © 2020 Tomas Skypala. All rights reserved.
//

import Foundation

enum IntersperseState {
    case element, separator

    mutating func flip() {
        self = self == .element ? .separator : .element
    }
}

extension Sequence {

    func intersperse(_ separator: Element) -> AnySequence<Element> {
        return intersperse({ separator })
    }

    func intersperse(_ separatorGenerator: @escaping () -> Element) -> AnySequence<Element> {

        return AnySequence<Element>({ () -> AnyIterator<Element> in

            var iterator = self.makeIterator()

            var current = iterator.next()

            var state = IntersperseState.element

            return AnyIterator({ () -> Element? in

                if current == nil { return nil }

                defer { state.flip() }

                if state == .element {
                    defer { current = iterator.next() }
                    return current
                } else {
                    return separatorGenerator()
                }

            })
        })
    }
}
