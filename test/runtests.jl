using BinaryTrees
using AbstractTrees
using Test

@testset "BinaryTrees.jl" begin
  @testset "AVLTree" begin
    # insert
    tree = AVLTree{Int,Int}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    @test tree[2] == 20
    @test tree[1] == 10
    @test tree[3] == 30

    # value conversion
    tree = AVLTree{Int,Float64}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    @test tree[2] isa Float64
    @test tree[2] == 20.0
    @test tree[1] isa Float64
    @test tree[1] == 10.0
    @test tree[3] isa Float64
    @test tree[3] == 30.0

    # update values
    tree = AVLTree{Int,Int}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    @test tree[2] == 20
    @test tree[1] == 10
    @test tree[3] == 30
    tree[2] = 22
    tree[1] = 11
    tree[3] = 33
    @test tree[2] == 22
    @test tree[1] == 11
    @test tree[3] == 33

    # right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[2] = 20
    tree[1] = 10
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[2] = 20
    tree[3] = 30
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[1] = 10
    tree[2] = 20
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[3] = 30
    tree[2] = 20
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # delete
    tree = AVLTree{Int,Int}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    # deleting a key that does not exist 
    # does not change the tree
    delete!(tree, 4)
    @test tree === tree
    delete!(tree, 3)
    @test !isnothing(tree.root)
    @test !isnothing(tree.root.left)
    @test isnothing(tree.root.right)
    delete!(tree, 1)
    @test !isnothing(tree.root)
    @test isnothing(tree.root.left)
    @test isnothing(tree.root.right)
    delete!(tree, 2)
    @test isnothing(tree.root)

    # right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[2] = 20
    tree[10] = 0
    tree[1] = 10
    delete!(tree, 10)
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[-10] = 0
    tree[2] = 20
    tree[3] = 30
    delete!(tree, -10)
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[1] = 10
    tree[10] = 0
    tree[2] = 20
    delete!(tree, 10)
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[-10] = 0
    tree[3] = 30
    tree[2] = 20
    delete!(tree, -10)
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # deleting the root node
    tree = AVLTree{Int,Int}()
    tree[4] = 40
    tree[2] = 20
    tree[5] = 50
    tree[1] = 10
    tree[3] = 30
    delete!(tree, 4)
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 5
    @test tree.root.right.left.key == 3

    # tree that accepts any types
    tree = AVLTree()
    tree[2] = 'A'
    tree[1] = 1.1
    tree[3] = "test"
    @test tree[2] == 'A'
    @test tree[1] == 1.1
    @test tree[3] == "test"
    delete!(tree, 3)
    @test !isnothing(tree.root)
    @test !isnothing(tree.root.left)
    @test isnothing(tree.root.right)
    delete!(tree, 1)
    @test !isnothing(tree.root)
    @test isnothing(tree.root.left)
    @test isnothing(tree.root.right)
    delete!(tree, 2)
    @test isnothing(tree.root)

    # AbstractTrees interface
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[2] = 20
    tree[4] = 40
    tree[1] = 10
    tree[5] = 50
    @test children(tree.root) === (tree.root.left, tree.root.right)
    @test children(tree.root.left) === (tree.root.left.left,)
    @test children(tree.root.right) === (tree.root.right.right,)
    @test children(tree.root.left.left) === ()
    @test children(tree.root.right.right) === ()
    @test nodevalue(tree.root) === tree.root
    @test NodeType(tree.root) === HasNodeType()
    @test nodetype(tree.root) === typeof(tree.root)

    # show
    tree = AVLTree{Int,Int}()
    @test sprint(show, MIME("text/plain"), tree) == "AVLTree()"
    tree[3] = 30
    tree[2] = 20
    tree[4] = 40
    tree[1] = 10
    tree[5] = 50
    @test sprint(show, MIME("text/plain"), tree) == """
    AVLTree
    3 => 30
    ├─ 2 => 20
    │  └─ 1 => 10
    └─ 4 => 40
       └─ 5 => 50"""
  end
end
