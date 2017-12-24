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

private typealias Tree = BTree<Int, Int>

func demoInsertion() {
    print("Insertion:")

    let bTree = Tree(order: 4)!
    let keys = [8, 13, 5, 0, 16, 7, 23, 48, 15]

    print("Keys to be inserted: \(keys)\n")

    for key in keys {
        bTree.insert(key, for: key)
        print(bTree)
    }

    print("\n\n")
}

func demoDeletion() {
    print("Deletion:")

    let bTree = Tree(order: 4)!

    let toInsert = Array(1...10)
    let toDelete = [6, 1, 3]

    print("Keys to be inserted: \(toInsert)")
    print("Keys to be deleted: \(toDelete)")

    for key in toInsert {
        bTree.insert(key, for: key)
    }

    print("Original tree: \(bTree)")

    //        [3, 6, 9]
    // [1, 2] [4, 5] [7, 8] [10]

    for keyToDelete in toDelete {
        print("Delete key: \(keyToDelete)")
        bTree.remove(keyToDelete)
        print(bTree)
    }

    print("\n\n")
}

func traversDemo() {
    print("Travers:")

    let bTree = Tree(order: 4)!

    for key in 1...20 {
        bTree.insert(key, for: key)
    }

    var arr = [Int]()
    bTree.traverseKeysInOrder {
        arr.append($0)
    }

    print(arr)
}

demoInsertion()
demoDeletion()
traversDemo()
