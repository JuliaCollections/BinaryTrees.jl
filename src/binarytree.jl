# ------------
# BINARY NODE
# ------------

abstract type BinaryNode end

"""
    BinaryTrees.key(node)

Key of the `node`.
"""
key(node::BinaryNode) = node.key

"""
    BinaryTrees.value(node)

Value of the `node`.
"""
value(node::BinaryNode) = node.value

"""
    BinaryTrees.left(node)

Left child of the `node`, if it does not exist, `nothing` is returned.
"""
left(node::BinaryNode) = node.left

"""
    BinaryTrees.right(node)

Right child of the `node`, if it does not exist, `nothing` is returned.
"""
right(node::BinaryNode) = node.right

# ------------
# BINARY TREE
# ------------

abstract type BinaryTree end

"""
    BinaryTrees.search(tree, key)

Search the tree for the node that has `key`.
If the tree does not have a node with `key`, `nothing` is returned.
"""
function search end

"""
    BinaryTrees.insert!(tree, key, value)

Insert a node into the tree with `key` and `value`.
If a node with `key` already exists, the value
of the node will be updated.
"""
function insert! end

"""
    BinaryTrees.delete!(tree, key)

Delete the node that has `key` from the tree.
"""
function delete! end

# -----------
# IO METHODS
# -----------

function Base.show(io::IO, ::MIME"text/plain", tree::BinaryTree)
  name = nameof(typeof(tree))
  if isnothing(tree.root)
    print(io, "$name()")
  else
    println(io, "$name")
    str = AbstractTrees.repr_tree(tree.root, context=io)
    print(io, rstrip(str)) # remove \n at end
  end
end

# --------------
# ABSTRACTTREES
# --------------

function AbstractTrees.children(node::BinaryNode)
  leftnode = left(node)
  rightnode = right(node)
  if !isnothing(leftnode) && !isnothing(rightnode)
    (leftnode, rightnode)
  elseif !isnothing(leftnode)
    (leftnode,)
  elseif !isnothing(rightnode)
    (rightnode,)
  else
    ()
  end
end

AbstractTrees.NodeType(::Type{<:BinaryNode}) = AbstractTrees.HasNodeType()
AbstractTrees.nodetype(T::Type{<:BinaryNode}) = T

function AbstractTrees.printnode(io::IO, node::BinaryNode)
  ioctx = IOContext(io, :compact => true, :limit => true)
  show(ioctx, key(node))
  print(ioctx, " => ")
  show(ioctx, value(node))
end
