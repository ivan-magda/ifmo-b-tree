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

// MARK: - BTree<Key: Comparable, Value>

/**
 *  B-Tree
 *
 *  A B-Tree is a self-balancing search tree, in which nodes can have more than two children.
 */
class BTree<Key: Comparable, Value> {

    // MARK: Instance Variables

    let order: Int

    var root: Node<Key, Value>!

    var numberOfKeys = 0

    // MARK: Init

    /**
     *  Designated initializer for the tree
     *
     *  See Node's extension (Basic limits and properties) for more info
     *  about min/max allowed keys/children.
     *
     *  - Parameters:
     *    - order: The order of the tree.
     */
    public init(order: Int) {
        assert(order > 2, "Order has to be greater than 2.")

        self.order = order
        self.root = Node<Key, Value>(owner: self)
    }
}

// MARK: - BTree (Search) -

extension BTree {

    /**
     *  Returns the value for a given `key`, returns nil if the `key` is not found.
     *
     *  - Parameters:
     *    - key: the key of the value to be returned
     */
    subscript(key: Key) -> Value? {
        return value(for: key)
    }

    /**
     *  Returns the value for a given `key`, returns nil if the `key` is not found.
     *
     *  - Parameters:
     *    - key: the key of the value to be returned
     */
    func value(for key: Key) -> Value? {
        guard root.numberOfKeys > 0 else {
            return nil
        }

        return root.value(for: key)
    }
}

// MARK: - BTree (Travers) -

extension BTree {

    /**
     *  Traverses the keys in order, executes `process` closure for every key.
     *
     *  - Parameters:
     *    - process: the closure to be executed for every key
     */
    public func traverseKeysInOrder(_ process: (Key) -> Void) {
        root.traverseKeysInOrder(process)
    }
}

// MARK: - BTree (Insertion) -

extension BTree {

    /**
     *  Inserts the `value` for the `key` into the tree.
     *
     *  - Parameters:
     *    - value: the value to be inserted for `key`
     *    - key: the key for the `value`
     */
    func insert(_ value: Value, for key: Key) {
        root.insert(value, for: key)

        if root.isTooLarge {
            splitRoot()
        }
    }

    /**
     *  Splits the root node of the tree.
     */
    private func splitRoot() {
        let middleIndex = root.numberOfKeys / 2

        let newRoot = Node<Key, Value>(
                owner: self,
                keys: [root.keys[middleIndex]],
                values: [root.values[middleIndex]],
                children: [root]
        )
        root.keys.remove(at: middleIndex)
        root.values.remove(at: middleIndex)

        let newRightChild = Node<Key, Value>(
                owner: self,
                keys: Array(root.keys[root.keys.indices.suffix(from: middleIndex)]),
                values: Array(root.values[root.values.indices.suffix(from: middleIndex)])
        )
        root.keys.removeSubrange(root.keys.indices.suffix(from: middleIndex))
        root.values.removeSubrange(root.values.indices.suffix(from: middleIndex))

        if root.children != nil {
            newRightChild.children = Array(
                    root.children![root.children!.indices.suffix(from: (middleIndex + 1))]
            )
            root.children!.removeSubrange(
                    root.children!.indices.suffix(from: (middleIndex + 1))
            )
        }

        newRoot.children!.append(newRightChild)
        root = newRoot
    }
}

// MARK: - BTree (Deletion) -

extension BTree {

    /**
     *  Removes `key` and the value associated with it from the tree.
     *
     *  - Parameters:
     *    - key: the key to remove
     */
    public func remove(_ key: Key) {
        guard root.numberOfKeys > 0 else {
            return
        }

        root.remove(key)

        if root.numberOfKeys == 0 && !root.isLeaf {
            root = root.children!.first!
        }
    }
}

// MARK: - BTree (CustomStringConvertible) -

extension BTree: CustomStringConvertible {
    public var description: String {
        return root.description
    }
}
