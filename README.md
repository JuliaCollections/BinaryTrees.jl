# BinaryTrees.jl

[![Build Status](https://github.com/eliascarv/BinaryTrees.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/eliascarv/BinaryTrees.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/eliascarv/BinaryTrees.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/eliascarv/BinaryTrees.jl)

## Overview

This package provides a collection of binary trees implemented in Julia. 

Currently, it includes the following binary trees:
* **AVL Tree**: A self-balancing binary search tree.

## Installation

To install BinaryTrees.jl, use the Julia's package manager:

```
] add https://github.com/eliascarv/BinaryTrees.jl
```

## AVL Tree

An AVL tree is a binary search tree that keeps itself balanced to ensure efficient search, insertion, and deletion operations.

### Example Usage

```julia
tree = AVLTree{Int,Float64}()

# add nodes to the tree
tree[2] = 2.2 # root node
tree[1] = 1.1 # left node
tree[3] = 3.3 # right node

# update the value of the node
tree[2] = 2.4

# get the value of the node using its key
tree[2] # 2.4
tree[1] # 1.1
tree[3] # 3.3

# delete nodes from the tree
delete!(tree, 1)
delete!(tree, 3)
```
