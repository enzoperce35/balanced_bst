require_relative 'tree.rb'

rand_num = Array.new(15) { rand(1..100) }
bal_bst = Tree.new(rand_num)

puts 'A balanced binary search tree of random numbers from 1-100'
bal_bst.pretty_print

puts "Balanced?: #{ bal_bst.balanced? }",
"level-order: #{ bal_bst.level_order }",
"preOrder: #{ bal_bst.preOrder }",
"inOrder: #{ bal_bst.inOrder }",
"postOrder: #{ bal_bst.postOrder }\n\n"

bal_bst.insert(150)
bal_bst.insert(250)
puts 'The binary search tree added with two numbers greater than 100'
bal_bst.pretty_print
puts "Balanced?: #{ bal_bst.balanced? }\n\n"

bal_bst.rebalance
puts 'The rebalanced binary search tree'
bal_bst.pretty_print
puts "Balanced?: #{ bal_bst.balanced? }",
"level-order: #{ bal_bst.level_order }",
"preOrder: #{ bal_bst.preOrder }",
"inOrder: #{ bal_bst.inOrder }",
"postOrder: #{ bal_bst.postOrder }"
