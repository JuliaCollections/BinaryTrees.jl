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
```
