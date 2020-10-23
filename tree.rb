require_relative 'node.rb'

class Tree < Node
  include Comparable
  attr_accessor :arr, :root

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = build_tree
  end

  # build the tree
  def build_tree(sorted_arr = arr , mid = nil)
    return nil if 0 > sorted_arr.length - 1
    mid = sorted_arr.length / 2
    root = Node.new(sorted_arr[mid])
    root.left = build_tree(sorted_arr[0, mid])
    root.right = build_tree(sorted_arr[mid + 1, sorted_arr.length])
    root
  end

  def <=>(other)
    root.data <=> other.root.data
  end

  # find the lowest value of a node
  def min(key)
    key = find(key) if !key.is_a? Node
    return key if key.left.nil? && key.right.nil?
    min(key.left)
  end

  # find the highest value of a node
  def max(key)
    key = find(key) if !key.is_a? Node
    return key if key.right.nil?
    max(key.right)
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
  def find_parent(key, node = root)
    return nil if node.nil?
    key = find(key) if !key.is_a? Node
    if node.left == key || node.right == key
      return node
    else
      find_parent(key, left_right(key.data, node))
    end
  end

  def left_right(key, node)
    case child_count(node)
    when 1
      node.left.nil? ? node.right : node.left
    when 2
      node.data > key ? node.left : node.right
    end
  end

  # find key from the tree nodes
  def find(key, node = root)
    return nil if node.nil?
    if key == node.data
      return node
    else
      find(key, left_right(key, node))
    end
  end

  # modify tree; delete key as target then use lower nodes as substitutes
  def delete(key)
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
  def insert(key, node = root)
    return node if node.data == key
    if child_count(node) == 0
      key < node.data ? node.left = Node.new(key) : node.right = Node.new(key)
    else
      insert(key, left_right(key, node))
    end
  end

  # return array of ordered values
  def preOrder(node = root, arr = [])
    return nil unless node.is_a? Node
    arr << node.data
    preOrder(node.left, arr) if !node.left.nil?
    preOrder(node.right, arr) if !node.right.nil?
    arr
  end

  def inOrder(node = root, arr = [])
    return nil unless node.is_a? Node
    inOrder(node.left, arr) if !node.left.nil?
    arr << node.data
    inOrder(node.right, arr) if !node.right.nil?
    arr
  end

  def postOrder(node = root, arr = [])
    return nil unless node.is_a? Node
    postOrder(node.left, arr) if !node.left.nil?
    postOrder(node.right, arr) if !node.right.nil?
    arr << node.data
    arr
  end

  # level_order method: recursion
  def level_order(node = root, visited = [], discovered = [])
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
  #def level_order(discovered = [root], visited = [])
  #  while discovered.length > 0
  #    current = discovered.shift
  #    discovered.push(current.left) unless current.left.nil?
  #    discovered.push(current.right) unless current.right.nil?
  #    visited.push(current.data)
  #  end
  #  visited
  #end

  # edges between the given key and the longest path leaf
  def height(key, count = 0, child = level_order(key).pop)
    count += 1
    if child == key
      return count - 1
    else
      parent = find_parent(child).data
      height(key, count, parent)
    end
  end

  # edges between the given key and the main root
  def depth(key, count = 0, child = key)
    count += 1
    if root.data == child
      return count - 1
    else
      parent = find_parent(child).data
      depth(key, count, parent)
    end
  end

  def balanced?
    diff = height(root.left.data) - height(root.right.data)
    diff.between?(-1,1)
  end

  def rebalance
    @root = build_tree(level_order(root).sort)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
