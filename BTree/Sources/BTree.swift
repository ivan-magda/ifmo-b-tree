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

    var rootNode: BTreeNode<Key, Value>!

    var numberOfKeys = 0

    // MARK: Init

    /**
     *  Designated initializer for the tree
     *
     *  - Parameters:
     *    - order: The order of the tree.
     */
    public init?(order: Int) {
        guard order > 0 else {
            print("Order has to be greater than 0.")
            return nil
        }

        self.order = order
        self.rootNode = BTreeNode<Key, Value>(owner: self)
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
        guard rootNode.numberOfKeys > 0 else {
            return nil
        }

        return rootNode.value(for: key)
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
        rootNode.insert(value, for: key)

        if rootNode.isTooLarge {
            splitRoot()
        }
    }

    /**
     *  Splits the root node of the tree.
     */
    private func splitRoot() {
        let middleIndex = rootNode.numberOfKeys / 2

        let newRoot = BTreeNode<Key, Value>(
                owner: self,
                keys: [rootNode.keys[middleIndex]],
                values: [rootNode.values[middleIndex]],
                children: [rootNode]
        )
        rootNode.keys.remove(at: middleIndex)
        rootNode.values.remove(at: middleIndex)

        let newRightChild = BTreeNode<Key, Value>(
                owner: self,
                keys: Array(rootNode.keys[rootNode.keys.indices.suffix(from: middleIndex)]),
                values: Array(rootNode.values[rootNode.values.indices.suffix(from: middleIndex)])
        )
        rootNode.keys.removeSubrange(rootNode.keys.indices.suffix(from: middleIndex))
        rootNode.values.removeSubrange(rootNode.values.indices.suffix(from: middleIndex))

        if rootNode.children != nil {
            newRightChild.children = Array(
                    rootNode.children![rootNode.children!.indices.suffix(from: (middleIndex + 1))]
            )
            rootNode.children!.removeSubrange(
                    rootNode.children!.indices.suffix(from: (middleIndex + 1))
            )
        }

        newRoot.children!.append(newRightChild)
        rootNode = newRoot
    }
}

// MARK: - BTree (CustomStringConvertible) -

extension BTree: CustomStringConvertible {
    public var description: String {
        return rootNode.description
    }
}
