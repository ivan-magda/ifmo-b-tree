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

class BTree<Key: Comparable, Value> {

    /**
     *  The order of the B-Tree.
     *
     *  The number of keys in every node should be in the [order, 2 * order] range,
     *  except the root node which is allowed to contain less keys than the value of order.
     */
    public let order: Int

    private var rootNode: BTreeNode<Key, Value>!

    private(set) public var numberOfKeys = 0

    /**
     *  Designated initializer for the tree
     *
     *  - Parameters:
     *    - order: The order of the tree.
     */
    public init?(order: Int) {
        guard order > 1 else {
            print("Order has to be greater than 1.")
            return nil
        }

        self.order = order
        self.rootNode = BTreeNode<Key, Value>(owner: self)
    }
}
