// Copyright (c) 2017 Ivan Magda.
// This file is part of Attabench: https://github.com/attaswift/Attabench
// For licensing information, see the file LICENSE.md in the Git repository above.

import Benchmarking

let benchmark = Benchmark<([Int], [Int])>(title: "SortedSet")
benchmark.descriptiveTitle = "SortedSet operations"
benchmark.descriptiveAmortizedTitle = "SortedSet operations (amortized)"

benchmark.addTask(title: "SortedArray.insert") { input, lookups in
    return { timer in
        var set = SortedArray<Int>()
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "SortedArray.contains") { input, lookups in
    let set = SortedArray<Int>(sortedElements: 0 ..< input.count) // Cheating
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "SortedArray.for-in") { input, lookups in
    let set = SortedArray<Int>(sortedElements: 0 ..< input.count) // Cheating
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BinaryTree.insert") { input, lookups in
    return { timer in
        var set = BinaryTree<Int>()
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BinaryTree.contains") { input, lookups in
    var set = BinaryTree<Int>()
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BinaryTree.for-in") { input, lookups in
    var set = BinaryTree<Int>()
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        var index = set.startIndex
        while index != set.endIndex {
            let element = set[index]
            guard element == i else { fatalError() }
            i += 1
            set.formIndex(after: &index)
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "RedBlackTree.insert") { input, lookups in
    return { timer in
        var set = RedBlackTree2<Int>()
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "RedBlackTree.contains") { input, lookups in
    var set = RedBlackTree2<Int>()
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "RedBlackTree.for-in") { input, lookups in
    var set = RedBlackTree2<Int>()
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        var index = set.startIndex
        while index != set.endIndex {
            let element = set[index]
            guard element == i else { fatalError() }
            i += 1
            set.formIndex(after: &index)
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.insert(4)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 4)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(8)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 8)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(16)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 16)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(32)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 32)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(64)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 64)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(128)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 128)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(256)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 256)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(512)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 512)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(1024)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 1024)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.insert(2048)") { input, lookups in
    return { timer in
        var set = BTree<Int>(order: 2048)
        timer.measure {
            for value in input {
                set.insert(value)
            }
        }
    }
}

benchmark.addTask(title: "BTree.contains(4)") { input, lookups in
    var set = BTree<Int>(order: 4)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(8)") { input, lookups in
    var set = BTree<Int>(order: 8)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(16)") { input, lookups in
    var set = BTree<Int>(order: 16)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(32)") { input, lookups in
    var set = BTree<Int>(order: 32)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(64)") { input, lookups in
    var set = BTree<Int>(order: 64)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(128)") { input, lookups in
    var set = BTree<Int>(order: 128)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(256)") { input, lookups in
    var set = BTree<Int>(order: 256)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(512)") { input, lookups in
    var set = BTree<Int>(order: 512)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(1024)") { input, lookups in
    var set = BTree<Int>(order: 1024)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.contains(2048)") { input, lookups in
    var set = BTree<Int>(order: 2048)
    for value in input {
        set.insert(value)
    }
    return { timer in
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
}

benchmark.addTask(title: "BTree.for-in(4)") { input, lookups in
    var set = BTree<Int>(order: 4)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(8)") { input, lookups in
    var set = BTree<Int>(order: 8)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(16)") { input, lookups in
    var set = BTree<Int>(order: 16)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(32)") { input, lookups in
    var set = BTree<Int>(order: 32)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(64)") { input, lookups in
    var set = BTree<Int>(order: 64)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(128)") { input, lookups in
    var set = BTree<Int>(order: 128)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(256)") { input, lookups in
    var set = BTree<Int>(order: 256)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(512)") { input, lookups in
    var set = BTree<Int>(order: 512)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(1024)") { input, lookups in
    var set = BTree<Int>(order: 1024)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}

benchmark.addTask(title: "BTree.for-in(2048)") { input, lookups in
    var set = BTree<Int>(order: 2048)
    for value in input {
        set.insert(value)
    }
    return { timer in
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}


benchmark.start()
