# ---------
# AVL NODE
# ---------

mutable struct AVLNode{K,V} <: BinaryNode
  key::K
  value::V
  height::Int
  left::Union{AVLNode{K,V},Nothing}
  right::Union{AVLNode{K,V},Nothing}
end

AVLNode(key, value) = AVLNode(key, value, 1, nothing, nothing)

Base.convert(::Type{AVLNode{K,V}}, node::AVLNode) where {K,V} =
  AVLNode{K,V}(node.key, node.value, node.height, node.left, node.right)

Base.convert(::Type{AVLNode{K,V}}, node::AVLNode{K,V}) where {K,V} = node

# ---------
# AVL TREE
# ---------

"""
    AVLTree{K,V}()

Construct an empty AVL Tree with keys of type `K`
and values of type `V`.

    AVLTree{K}()

Construct an empty AVL tree with no values and keys of type `K`.

The keys of AVL Tree must implement ordering relations (`>`, `<`).

# Examples

```julia
tree = AVLTree{Int,Float64}()

# insert nodes into the tree
BinaryTrees.insert!(tree, 2, 2.2) # root node
BinaryTrees.insert!(tree, 1, 1.1) # left node
BinaryTrees.insert!(tree, 3, 3.3) # right node

# update the value of the node
BinaryTrees.insert!(tree, 2, 2.4)

# search for nodes using their keys
BinaryTrees.search(tree, 2) # root node
BinaryTrees.search(tree, 1) # left node
BinaryTrees.search(tree, 3) # right node

# delete nodes from the tree
BinaryTrees.delete!(tree, 1)
BinaryTrees.delete!(tree, 3)

# tree that only has keys
tree = AVLTree{Int}()
BinaryTrees.insert!(tree, 2) # root node
BinaryTrees.insert!(tree, 1) # left node
BinaryTrees.insert!(tree, 3) # right node
```
"""
mutable struct AVLTree{K,V} <: BinaryTree
  root::Union{AVLNode{K,V},Nothing}
end

AVLTree{K,V}() where {K,V} = AVLTree{K,V}(nothing)
AVLTree{K}() where {K} = AVLTree{K,Nothing}()

search(tree::AVLTree{K}, key::K) where {K} = _search(tree, key)

function insert!(tree::AVLTree{K}, key::K, value) where {K}
  tree.root = _insert!(tree.root, key, value)
  tree
end

insert!(tree::AVLTree{K,Nothing}, key::K) where {K} = insert!(tree, key, nothing)

function delete!(tree::AVLTree{K}, key::K) where {K}
  tree.root = _delete!(tree.root, key)
  tree
end

# -----------------
# HELPER FUNCTIONS
# -----------------

function _search(tree, key)
  node = tree.root
  while !isnothing(node)
    if key < node.key
      node = node.left
    elseif key > node.key
      node = node.right
    else
      return node
    end
  end
  nothing
end

function _insert!(root, key, value)
  if isnothing(root)
    return AVLNode(key, value)
  elseif key < root.key
    root.left = _insert!(root.left, key, value)
  elseif key > root.key
    root.right = _insert!(root.right, key, value)
  else
    root.value = value
    return root
  end

  _updateheight!(root)

  bf = _balancefactor(root)

  if bf > 1 && key < root.left.key
    _rightrotate!(root)
  elseif bf < -1 && key > root.right.key
    _leftrotate!(root)
  elseif bf > 1 && key > root.left.key
    _leftrightrotate!(root)
  elseif bf < -1 && key < root.right.key
    _rightleftrotate!(root)
  else
    root
  end
end

function _delete!(root, key)
  if isnothing(root)
    return root
  elseif key < root.key
    root.left = _delete!(root.left, key)
  elseif key > root.key
    root.right = _delete!(root.right, key)
  else
    if isnothing(root.left)
      return root.right
    elseif isnothing(root.right)
      return root.left
    else
      temp = _minnode(root.right)
      root.key = temp.key
      root.value = temp.value
      root.right = _delete!(root.right, temp.key)
    end
  end

  _updateheight!(root)

  bf = _balancefactor(root)

  if bf > 1 && _balancefactor(root.left) ≥ 0
    _rightrotate!(root)
  elseif bf < -1 && _balancefactor(root.right) ≤ 0
    _leftrotate!(root)
  elseif bf > 1 && _balancefactor(root.left) < 0
    _leftrightrotate!(root)
  elseif bf < -1 && _balancefactor(root.right) > 0
    _rightleftrotate!(root)
  else
    root
  end
end

function _leftrotate!(node)
  B = node.right
  Y = B.left

  B.left = node
  node.right = Y

  _updateheight!(node)
  _updateheight!(B)

  B
end

function _rightrotate!(node)
  A = node.left
  Y = A.right

  A.right = node
  node.left = Y

  _updateheight!(node)
  _updateheight!(A)

  A
end

function _leftrightrotate!(node)
  node.left = _leftrotate!(node.left)
  _rightrotate!(node)
end

function _rightleftrotate!(node)
  node.right = _rightrotate!(node.right)
  _leftrotate!(node)
end

function _updateheight!(node)
  node.height = 1 + max(_height(node.left), _height(node.right))
  node
end

_height(node) = isnothing(node) ? 0 : node.height

_balancefactor(node) = isnothing(node) ? 0 : _height(node.left) - _height(node.right)

_minnode(node) = isnothing(node) || isnothing(node.left) ? node : _minnode(node.left)
