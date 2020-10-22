require_relative 'tree.rb'

bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
bst2 = Tree.new([7, 11, 12, 25, 98, 423, 3085, 76, 3, 59, 2022, 2017])

#bst.tree.right.data = nil

bst.pretty_print
#bst.delete(8)
#bst.insert(25)
bst.pretty_print

#p bst > bst2

#p bst.preOrder
#p bst.inOrder
#p bst.postOrder
#p bst.level_order

#p bst.height
#p bst.depth


