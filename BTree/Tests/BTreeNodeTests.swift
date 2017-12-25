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

import XCTest

class BTreeNodeTests: XCTestCase {
    
    let bTree = BTree<Int, Int>(order: 4)
    var root: Node<Int, Int>!
    var leftChild: Node<Int, Int>!
    var rightChild: Node<Int, Int>!
    
    override func setUp() {
        super.setUp()
        
        root = Node(owner: bTree)
        leftChild = Node(owner: bTree)
        rightChild = Node(owner: bTree)
        
        root.insert(1, for: 1)
        root.children = [leftChild, rightChild]
    }
    
    func testIsLeafRoot() {
        XCTAssertFalse(root.isLeaf)
    }
    
    func testIsLeafLeaf() {
        XCTAssertTrue(leftChild.isLeaf)
        XCTAssertTrue(rightChild.isLeaf)
    }
    
    func testOwner() {
        XCTAssert(root.owner === bTree)
        XCTAssert(leftChild.owner === bTree)
        XCTAssert(rightChild.owner === bTree)
    }
    
    func testNumberOfKeys() {
        XCTAssertEqual(root.numberOfKeys, 1)
        XCTAssertEqual(leftChild.numberOfKeys, 0)
        XCTAssertEqual(rightChild.numberOfKeys, 0)
    }
    
    func testChildren() {
        XCTAssertEqual(root.children!.count, 2)
    }
}
