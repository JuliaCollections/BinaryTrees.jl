using BinaryTrees
using AbstractTrees
using Test

const BT = BinaryTrees

@testset "BT.jl" begin
  @testset "AVLTree" begin
    # insert
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    @test BT.value(BT.search(tree, 2)) == 20
    @test BT.value(BT.search(tree, 1)) == 10
    @test BT.value(BT.search(tree, 3)) == 30

    # value conversion
    tree = AVLTree{Int,Float64}()
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    @test BT.value(BT.search(tree, 2)) isa Float64
    @test BT.value(BT.search(tree, 2)) == 20.0
    @test BT.value(BT.search(tree, 1)) isa Float64
    @test BT.value(BT.search(tree, 1)) == 10.0
    @test BT.value(BT.search(tree, 3)) isa Float64
    @test BT.value(BT.search(tree, 3)) == 30.0

    # update values
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    @test BT.value(BT.search(tree, 2)) == 20
    @test BT.value(BT.search(tree, 1)) == 10
    @test BT.value(BT.search(tree, 3)) == 30
    BT.insert!(tree, 2, 22)
    BT.insert!(tree, 1, 11)
    BT.insert!(tree, 3, 33)
    @test BT.value(BT.search(tree, 2)) == 22
    @test BT.value(BT.search(tree, 1)) == 11
    @test BT.value(BT.search(tree, 3)) == 33

    # right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 1, 10)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 3, 30)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 2, 20)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # delete
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    # deleting a key that does not exist 
    # does not change the tree
    BT.delete!(tree, 4)
    @test tree === tree
    BT.delete!(tree, 3)
    @test !isnothing(tree.root)
    @test !isnothing(BT.left(tree.root))
    @test isnothing(BT.right(tree.root))
    BT.delete!(tree, 1)
    @test !isnothing(tree.root)
    @test isnothing(BT.left(tree.root))
    @test isnothing(BT.right(tree.root))
    BT.delete!(tree, 2)
    @test isnothing(tree.root)

    # right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 10, 0)
    BT.insert!(tree, 1, 10)
    BT.delete!(tree, 10)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, -10, 0)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 3, 30)
    BT.delete!(tree, -10)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 10, 0)
    BT.insert!(tree, 2, 20)
    BT.delete!(tree, 10)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, -10, 0)
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.delete!(tree, -10)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 3

    # deleting the root node
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 5, 50)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    BT.delete!(tree, 4)
    @test tree.root |> BT.key == 2
    @test tree.root |> BT.left |> BT.key == 1
    @test tree.root |> BT.right |> BT.key == 5
    @test tree.root |> BT.right |> BT.left |> BT.key == 3

    # tree that accepts any types
    tree = AVLTree()
    BT.insert!(tree, 2, 'A')
    BT.insert!(tree, 1, 1.1)
    BT.insert!(tree, 3, "test")
    @test BT.value(BT.search(tree, 2)) == 'A'
    @test BT.value(BT.search(tree, 1)) == 1.1
    @test BT.value(BT.search(tree, 3)) == "test"
    BT.delete!(tree, 3)
    @test !isnothing(tree.root)
    @test !isnothing(BT.left(tree.root))
    @test isnothing(BT.right(tree.root))
    BT.delete!(tree, 1)
    @test !isnothing(tree.root)
    @test isnothing(BT.left(tree.root))
    @test isnothing(BT.right(tree.root))
    BT.delete!(tree, 2)
    @test isnothing(tree.root)

    # AbstractTrees interface
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 5, 50)
    root = tree.root
    left = BT.left(root)
    right = BT.right(root)
    leftleft = BT.left(left)
    rightright = BT.right(right)
    @test children(root) === (left, right)
    @test children(left) === (leftleft,)
    @test children(right) === (rightright,)
    @test children(leftleft) === ()
    @test children(rightright) === ()
    @test nodevalue(root) === root
    @test NodeType(root) === HasNodeType()
    @test nodetype(root) === typeof(root)

    # show
    tree = AVLTree{Int,Int}()
    @test sprint(show, MIME("text/plain"), tree) == "AVLTree()"
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 5, 50)
    @test sprint(show, MIME("text/plain"), tree) == """
    AVLTree
    3 => 30
    ├─ 2 => 20
    │  └─ 1 => 10
    └─ 4 => 40
       └─ 5 => 50"""
  end
end
