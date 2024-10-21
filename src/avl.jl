# ---------
# AVL NODE
# ---------

mutable struct AVLNode{K,V}
  key::K
  value::V
  left::Union{AVLNode{K,V},Nothing}
  right::Union{AVLNode{K,V},Nothing}
  height::Int
end

AVLNode(key, value) = AVLNode(key, value, nothing, nothing, 1)

Base.convert(::Type{AVLNode{K,V}}, node::AVLNode) where {K,V} =
  AVLNode{K,V}(node.key, node.value, node.left, node.right, node.height)

function AbstractTrees.children(node::AVLNode)
  if !isnothing(node.left) && !isnothing(node.right)
    (node.left, node.right)
  elseif !isnothing(node.left)
    (node.left,)
  elseif !isnothing(node.right)
    (node.right,)
  else
    ()
  end
end

AbstractTrees.nodevalue(node::AVLNode) = node.value

AbstractTrees.NodeType(::Type{<:AVLNode}) = AbstractTrees.HasNodeType()
AbstractTrees.nodetype(T::Type{<:AVLNode}) = T

function AbstractTrees.printnode(io::IO, node::AVLNode)
  ioctx = IOContext(io, :compact => true, :limit => true)
  show(ioctx, node.key)
  print(ioctx, " => ")
  show(ioctx, node.value)
end

# ---------
# AVL TREE
# ---------

"""
    AVLTree{K,V}()

Construct an empty AVL Tree with keys of type `K`
and values of type `V`.

    AVLTree()

Construct an empty AVL Tree that stores keys and values
of any type, alias for `AVLTree{Any,Any}()`.

The keys of AVL Tree  must implement sorting operators (`>`, `<`)
and comparison operators (`=`, `≠`)

# Examples

```julia
tree = AVLTree{Int,Float64}()

# add nodes to the tree
tree[2] = 2.2 # root node
tree[1] = 1.1 # left node
tree[3] = 3.3 # right node

# update the value of a node
tree[2] = 2.4

# get the value of a node using its key
tree[2] # 2.4
tree[1] # 1.1
tree[3] # 3.3

# delete nodes from the tree
delete!(tree, 1)
delete!(tree, 3)
```
"""
mutable struct AVLTree{K,V}
  root::Union{AVLNode{K,V},Nothing}
end

AVLTree{K,V}() where {K,V} = AVLTree{K,V}(nothing)
AVLTree() = AVLTree{Any,Any}()

"""
    getindex(tree::AVLTree{K}, key::K) where {K}

Get the value stored in the node that has `key`.
"""
function Base.getindex(tree::AVLTree{K}, key::K) where {K}
  node = _search(tree, key)
  isnothing(node) && throw(KeyError(key))
  node.value
end

"""
    setindex!(tree::AVLTree{K}, value, key::K) where {K}

Add a node to the tree with `key` and `value`.
If a node with `key` already exists, the value
of the node will be updated.
"""
function Base.setindex!(tree::AVLTree{K}, value, key::K) where {K}
  tree.root = _insert!(tree.root, key, value)
  tree
end

"""
    delete!(tree::AVLTree{K}, key::K) where {K}

Delete the node that has `key` from the tree.
"""
function Base.delete!(tree::AVLTree{K}, key::K) where {K}
  tree.root = _delete!(tree.root, key)
  tree
end

function Base.show(io::IO, ::MIME"text/plain", tree::AVLTree)
  if isnothing(tree.root)
    print(io, "AVLTree()")
  else
    println(io, "AVLTree")
    str = AbstractTrees.repr_tree(tree.root, context=io)
    print(io, str[begin:(end - 1)]) # remove \n at end
  end
end

# -----------------
# HELPER FUNCTIONS
# -----------------

function _search(tree, key)
  node = tree.root
  while !isnothing(node) && key ≠ node.key
    node = key < node.key ? node.left : node.right
  end
  node
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
