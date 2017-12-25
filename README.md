# B-tree
B-tree is a self-balancing tree data structure that keeps data sorted and allows searches, sequential access, insertions, and deletions in logarithmic time. The B-tree is a generalization of a binary search tree in that a node can have more than two children. Unlike self-balancing binary search trees, the B-tree is optimized for systems that read and write large blocks of data. B-trees are a good example of a data structure for external memory. It is commonly used in databases and filesystems.

### The Code:
- Searching:
  - `value(for:)` method searches for the given key and if it's in the tree, it returns the value associated with it,
  else it returns `nil`.
- Insertion:
  - The method `insert(_:for:)` does the insertion. After it has inserted a key, as the recursion goes up every node checks the number of keys in its child.
  - if a node has too many keys, its parent calls the `split(child:atIndex:)` method on it.
  - If the root has too many nodes after the insertion the tree calls the `splitRoot()` method.
- Deletion:
  - `remove(_:)` method removes the given key from the tree. After a key has been deleted,
every node checks the number of keys in its child. If a child has less nodes than the order of the tree, it calls the `fix(childWithTooFewKeys:atIndex:)` method.
  - `fix(childWithTooFewKeys:atIndex:)` method decides which way to fix the child (by moving a key to it, or by merging it), then calls `move(keyAtIndex:to:from:at:)` or `merge(child:atIndex:to:)` method according to its choice.
  
### Benchmarks Results:
- [Charts](./Resources)

## Helpful Links:
- [Wikipedia](https://en.wikipedia.org/wiki/B-tree)
- [geeksforgeeks](https://www.geeksforgeeks.org/b-tree-set-1-introduction-2/)
- [cs.cornell.edu](https://www.cs.cornell.edu/courses/cs3110/2009fa/recitations/rec25.html)

## LICENSE
This project is open-sourced software licensed under the MIT License.

See the [LICENSE](./LICENSE) file for more information.
