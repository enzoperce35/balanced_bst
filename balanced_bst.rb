class Node
    attr_accessor :data, :left, :right

    def initialize(data = nil, left = nil, right = nil)
      @data = data
      @left = left
      @right = right
    end
  end

  class Tree < Node
    include Comparable
    attr_accessor :arr, :tree, :root

    def initialize(arr)
      @arr = arr.uniq.sort
      @tree = build_tree
      @root = tree.data
    end

    # build the tree
    def build_tree(sorted_arr = arr , mid = nil)
      return nil if 0 > sorted_arr.length - 1
      mid = sorted_arr.length / 2
      node = Node.new(sorted_arr[mid])
      node.left = build_tree(sorted_arr[0, mid])
      node.right = build_tree(sorted_arr[mid + 1, sorted_arr.length])
      node
    end

    def <=>(other)
      tree.data <=> other.tree.data
    end

    # find the lowest value of a node
    def min(root)
      root = find(root) if !root.is_a? Node
      return root if root.left.nil? && root.right.nil?
      min(root.left)
    end

    # find the highest value of a node
    def max(root)
      root = find(root) if !root.is_a? Node
      return root if root.right.nil?
      max(root.right)
    end

    # count the children of the node
    def child_count(node, count = 0)
      return count if node.nil?
      if !node.is_a? Node
        child_count(find(node))
      else
        count += 1 if !node.left.nil?
        count += 1 if !node.right.nil?
      end
      count
    end

    # find the parent node of the child node
    def find_parent(child, node = tree)
      child = find(child) if !child.is_a? Node
      if node.left == child || node.right == child
        return node
      else
        dir = node.data > child.data ? node.left : node.right
        find_parent(child, dir)
      end
    end

    # find key from the tree nodes
    def find(key, node = tree)
      return nil if node.nil?
      if key == node.data
        return node
      else
        child = key < node.data ? node.left : node.right
        find(key, child)
      end
    end

    # modify tree; delete key as target then use lower nodes as substitutes
    def delete(key, node = tree)
      tar = find(key)
      case child_count(tar)
      when 2
        sub = tar.right.data == nil ? max(tar.left) : min(tar.right)
      when 1
        sub = tar.right.nil? ? tar.left : tar.right
      when 0
        sub = nil
      end
      modify(tar, sub)
    end

    def modify(tar, sub)
      if sub.nil?
        parent = find_parent(tar)
        parent.left == tar ? parent.left = sub : parent.right = sub
      else
        temp = sub.data
        delete(sub.data)
        tar.data = temp
      end
    end

    # insert a new node into the leaf
    def insert(key, node = tree)
      return node if node.data == key
      case child_count(node)
      when 0
        key < node.data ? node.left = Node.new(key) : node.right = Node.new(key)
      when 1
        insert(key, node.left.nil? ? node.right : node.left)
      when 2
        insert(key, node.data > key ? node.left : node.right)
      end
    end

    # return array of ordered values
    def preOrder(node = tree, arr = [])
      return nil unless node.is_a? Node
      arr << node.data
      preOrder(node.left, arr) if !node.left.nil?
      preOrder(node.right, arr) if !node.right.nil?
      arr
    end

    def inOrder(node = tree, arr = [])
      return nil unless node.is_a? Node
      inOrder(node.left, arr) if !node.left.nil?
      arr << node.data
      inOrder(node.right, arr) if !node.right.nil?
      arr
    end

    def postOrder(node = tree, arr = [])
      return nil unless node.is_a? Node
      postOrder(node.left, arr) if !node.left.nil?
      postOrder(node.right, arr) if !node.right.nil?
      arr << node.data
      arr
    end

    # level_order method: recursion
    def level_order(node = tree, visited = [], discovered = [])
      return nil if node.nil?
      node = find(node) unless node.is_a? Node
      current = node
      discovered.push(current.left) unless current.left.nil?
      discovered.push(current.right) unless current.right.nil?
      visited.push(current.data)
      level_order(discovered.shift, visited, discovered)
      visited
    end

    ## level order method: iteration
    #def level_order(discovered = [tree], visited = [])
    #  while discovered.length > 0
    #    current = discovered.shift
    #    discovered.push(current.left) unless current.left.nil?
    #    discovered.push(current.right) unless current.right.nil?
    #    visited.push(current.data)
    #  end
    #  visited
    #end

    def pretty_print(node = tree, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  end

  bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
  bst2 = Tree.new([7, 11, 12, 25, 98, 423, 3085, 76, 3, 59, 2022, 2017])

  #bst.tree.right.data = nil

  bst.pretty_print
  #bst.delete(8)
  bst.insert(25)
  bst.pretty_print

  #p bst > bst2

  #p bst.preOrder
  #p bst.inOrder
  #p bst.postOrder
  p bst.level_order(67)