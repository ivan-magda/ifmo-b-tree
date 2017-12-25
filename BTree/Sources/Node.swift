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

// MARK: - Node<Key: Comparable, Value>

class Node<Key: Comparable, Value> {

    /**
     * The tree that owns the node.
     */
    unowned var owner: BTree<Key, Value>

    var keys = [Key]()
    var values = [Value]()
    var children: [Node]?

    var numberOfKeys: Int {
        return keys.count
    }

    init(owner: BTree<Key, Value>) {
        self.owner = owner
    }

    convenience init(owner: BTree<Key, Value>, keys: [Key], values: [Value], children: [Node]? = nil) {
        self.init(owner: owner)
        self.keys += keys
        self.values += values
        self.children = children
    }
}

// MARK: - Node (Basic limits and properties) -

extension Node {

    var maxChildren: Int {
        return owner.order
    }

    var minChildren: Int {
        return (maxChildren + 1) / 2
    }

    var maxKeys: Int {
        return maxChildren - 1
    }

    var minKeys: Int {
        return minChildren - 1
    }

    var isLeaf: Bool {
        return children == nil || children!.isEmpty
    }

    var isTooSmall: Bool {
        return keys.count < minKeys
    }

    var isTooLarge: Bool {
        return keys.count > maxKeys
    }

    var isBalanced: Bool {
        return keys.count >= minKeys && keys.count <= maxKeys
    }
}

// MARK: Node (Search)

extension Node {

    /**
     *  Returns the value for a given `key`, otherwise returns nil if the `key` is not found.
     *
     *  - Parameters:
     *    - key: the key of the value to be returned
     */
    func value(for key: Key) -> Value? {
        var index = keys.startIndex

        while (index + 1) < keys.endIndex && key > keys[index] {
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

// MARK: - Node (Travers) -

extension Node {

    /**
     *  Traverses the keys in order, executes `process` closure for every key.
     *
     *  - Parameters:
     *    - process: the closure to be executed for every key
     */
    func traverseKeysInOrder(_ process: (Key) -> Void) {
        for i in 0..<numberOfKeys {
            children?[i].traverseKeysInOrder(process)
            process(keys[i])
        }

        children?.last?.traverseKeysInOrder(process)
    }
}

// MARK: - Node (Insertion)  -

extension Node {

    /**
     *  Inserts `value` for `key` to the node
     *
     *  - Parameters:
     *    - value: the value to be inserted for `key`
     *    - key: the key for the `value`
     */
    func insert(_ value: Value, for key: Key) {
        var index = keys.startIndex

        while index < keys.endIndex && keys[index] < key {
            index += 1
        }

        if index < keys.endIndex && keys[index] == key {
            values[index] = value
        } else if isLeaf {
            keys.insert(key, at: index)
            values.insert(value, at: index)
            owner.numberOfKeys += 1
        } else {
            children![index].insert(value, for: key)

            if children![index].isTooLarge {
                split(child: children![index], atIndex: index)
            }
        }
    }

    /**
     *  Splits `child` at `index`.
     *  The key-value pair at `index` gets moved up to the parent node,
     *  or if there is not an parent node, then a new parent node is created.
     *
     *  - Parameters:
     *    - child: the child to be split
     *    - index: the index of the key, which will be moved up to the parent
     */
    private func split(child: Node, atIndex index: Int) {
        let middleIndex = child.numberOfKeys / 2

        keys.insert(child.keys[middleIndex], at: index)
        values.insert(child.values[middleIndex], at: index)

        child.keys.remove(at: middleIndex)
        child.values.remove(at: middleIndex)

        let rightSibling = Node(
                owner: owner,
                keys: Array(child.keys[child.keys.indices.suffix(from: middleIndex)]),
                values: Array(child.values[child.values.indices.suffix(from: middleIndex)])
        )
        child.keys.removeSubrange(child.keys.indices.suffix(from: middleIndex))
        child.values.removeSubrange(child.values.indices.suffix(from: middleIndex))

        children!.insert(rightSibling, at: (index + 1))

        if child.children != nil {
            rightSibling.children = Array(
                    child.children![child.children!.indices.suffix(from: (middleIndex + 1))]
            )
            child.children!.removeSubrange(child.children!.indices.suffix(from: (middleIndex + 1)))
        }
    }
}

// MARK: - Node (Deletion) -

/**
 *  An enumeration to indicate a node's position according to another node.
 *
 *  Possible values:
 *    - left
 *    - right
 */
private enum BTreeNodePosition {
    case left
    case right
}

extension Node {

    private var inorderPredecessor: Node {
        if isLeaf {
            return self
        } else {
            return children!.last!.inorderPredecessor
        }
    }

    /**
     *  Removes `key` and the value associated with it from the node
     *  or one of its descendants.
     *
     *  - Parameters:
     *    - key: the key to be removed
     */
    func remove(_ key: Key) {
        var index = keys.startIndex

        // Perform a search for the `key` we want to remove.
        while (index + 1) < keys.endIndex && keys[index] < key {
            index = (index + 1)
        }

        if keys[index] == key {
            // If we have found the `key` and if we are on a leaf node,
            // we can remove the key.
            if isLeaf {
                keys.remove(at: index)
                values.remove(at: index)
                owner.numberOfKeys -= 1
            } else {
                // We need to overwrite `key` with its inorder predecessor `p`,
                // then we remove `p` from the leaf node.
                let child = children![index]
                let predecessor = child.inorderPredecessor

                keys[index] = predecessor.keys.last!
                values[index] = predecessor.values.last!
                child.remove(keys[index])

                if child.isTooSmall {
                    fix(childWithTooFewKeys: children![index], atIndex: index)
                }
            }
        } else if key < keys[index] {
            if let leftChild = children?[index] {
                leftChild.remove(key)

                if leftChild.isTooSmall {
                    fix(childWithTooFewKeys: leftChild, atIndex: index)
                }
            } else {
                print("The key:\(key) is not in the tree.")
            }
        } else {
            if let rightChild = children?[(index + 1)] {
                rightChild.remove(key)

                if rightChild.isTooSmall {
                    fix(childWithTooFewKeys: rightChild, atIndex: (index + 1))
                }
            } else {
                print("The key:\(key) is not in the tree")
            }
        }
    }

    /**
     *  Fixes `childWithTooFewKeys` by either moving a key to it from
     *  one of its neighbouring nodes, or by merging.
     *
     *  - Parameters:
     *    - child: the child to be fixed
     *    - index: the index of the child to be fixed in the current node
     */
    private func fix(childWithTooFewKeys child: Node, atIndex index: Int) {
        if (index - 1) >= 0 && children![(index - 1)].numberOfKeys > minKeys {
            move(keyAtIndex: (index - 1), to: child, from: children![(index - 1)], at: .left)
        } else if (index + 1) < children!.count && children![(index + 1)].numberOfKeys > minKeys {
            move(keyAtIndex: index, to: child, from: children![(index + 1)], at: .right)
        } else if (index - 1) >= 0 {
            merge(child: child, atIndex: index, to: .left)
        } else {
            merge(child: child, atIndex: index, to: .right)
        }
    }

    /**
     *  Moves the key at the specified `index` from `node` to
     *  the `targetNode` at `position`
     *
     *  - Parameters:
     *    - index: the index of the key to be moved in `node`
     *    - targetNode: the node to move the key into
     *    - node: the node to move the key from
     *    - position: the position of the from node relative to the targetNode
     */
    private func move(keyAtIndex index: Int, to targetNode: Node,
                      from node: Node, at position: BTreeNodePosition) {
        switch position {
        case .left:
            targetNode.keys.insert(keys[index], at: targetNode.keys.startIndex)
            targetNode.values.insert(values[index], at: targetNode.values.startIndex)

            keys[index] = node.keys.last!
            values[index] = node.values.last!

            node.keys.removeLast()
            node.values.removeLast()

            if !targetNode.isLeaf {
                targetNode.children!.insert(node.children!.last!, at: targetNode.children!.startIndex)
                node.children!.removeLast()
            }
        case .right:
            targetNode.keys.insert(keys[index], at: targetNode.keys.endIndex)
            targetNode.values.insert(values[index], at: targetNode.values.endIndex)

            keys[index] = node.keys.first!
            values[index] = node.values.first!

            node.keys.removeFirst()
            node.values.removeFirst()

            if !targetNode.isLeaf {
                targetNode.children!.insert(node.children!.first!, at: targetNode.children!.endIndex)
                node.children!.removeFirst()
            }
        }
    }

    /**
     *  Merges `child` at `position` to the node at the `position`.
     *
     *  - Parameters:
     *    - child: the child to be merged
     *    - index: the index of the child in the current node
     *    - position: the position of the node to merge into
     */
    private func merge(child: Node, atIndex index: Int, to position: BTreeNodePosition) {
        // Merge to the left or right sibling.
        switch position {
        case .left:
            children![(index - 1)].keys = children![(index - 1)].keys + [keys[(index - 1)]] + child.keys
            children![(index - 1)].values = children![(index - 1)].values + [values[(index - 1)]] + child.values

            keys.remove(at: (index - 1))
            values.remove(at: (index - 1))

            if !child.isLeaf {
                children![(index - 1)].children = children![(index - 1)].children! + child.children!
            }
        case .right:
            children![(index + 1)].keys = child.keys + [keys[index]] + children![(index + 1)].keys
            children![(index + 1)].values = child.values + [values[index]] + children![(index + 1)].values

            keys.remove(at: index)
            values.remove(at: index)

            if !child.isLeaf {
                children![(index + 1)].children = child.children! + children![(index + 1)].children!
            }
        }

        children!.remove(at: index)
    }
}

// MARK: - Node (CustomStringConvertible) -

extension Node: CustomStringConvertible {
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
