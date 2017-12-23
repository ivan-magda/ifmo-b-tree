/**
 * Copyright (c) 2017 Ivan Magda
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

// MARK: - BTreeNode<Key: Comparable, Value>

class BTreeNode<Key: Comparable, Value> {

    /**
     * The tree that owns the node.
     */
    unowned var owner: BTree<Key, Value>

    var keys = [Key]()
    var values = [Value]()
    var children: [BTreeNode]?

    var numberOfKeys: Int {
        return keys.count
    }

    init(owner: BTree<Key, Value>) {
        self.owner = owner
    }

    convenience init(owner: BTree<Key, Value>, keys: [Key], values: [Value], children: [BTreeNode]? = nil) {
        self.init(owner: owner)
        self.keys += keys
        self.values += values
        self.children = children
    }
}

// MARK: - BTreeNode (Basic limits and properties) -

extension BTreeNode {
    var isLeaf: Bool {
        return children == nil || children!.isEmpty
    }

    var isTooLarge: Bool {
        return keys.count >= owner.order
    }
}

// MARK: BTreeNode (Search)

extension BTreeNode {

    /**
     *  Returns the value for a given `key`, otherwise returns nil if the `key` is not found.
     *
     *  - Parameters:
     *    - key: the key of the value to be returned
     */
    func value(for key: Key) -> Value? {
        var index = keys.startIndex

        while index < keys.count && key > keys[index] {
            index += 1
        }

        if key == keys[index] {
            return values[index]
        } else if key < keys[index] {
            return children?[index].value(for: key)
        } else {
            return children?[(index + 1)].value(for: key)
        }
    }
}

// MARK: - BTreeNode (CustomStringConvertible) -

extension BTreeNode: CustomStringConvertible {
    var description: String {
        var str = "\(keys)"

        if !isLeaf {
            for child in children! {
                str += child.description
            }
        }

        return str
    }
}
