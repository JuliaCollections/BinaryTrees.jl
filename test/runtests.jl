using BinaryTrees
using AbstractTrees
using Test

const BT = BinaryTrees

@testset "BT.jl" begin
  @testset "AVLTree" begin
    # internal node conversion
    node1 = BT.AVLNode(1, 2)
    node2 = convert(BT.AVLNode{Float64,Float64}, node1)
    @test node2 isa BT.AVLNode{Float64,Float64}
    @test BT.key(node2) == 1.0
    @test BT.value(node2) == 2.0
    node3 = convert(typeof(node1), node1)
    @test node3 === node1

    # insert & search
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
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 3, 30)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 2, 20)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

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
    @test !isnothing(BT.root(tree))
    @test !isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 1)
    @test !isnothing(BT.root(tree))
    @test isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 2)
    @test isnothing(BT.root(tree))

    # right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 10, 0)
    BT.insert!(tree, 1, 10)
    BT.delete!(tree, 10)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, -10, 0)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 3, 30)
    BT.delete!(tree, -10)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 10, 0)
    BT.insert!(tree, 2, 20)
    BT.delete!(tree, 10)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, -10, 0)
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.delete!(tree, -10)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 3

    # deleting the root node
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 5, 50)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 3, 30)
    BT.delete!(tree, 4)
    @test tree |> BT.root |> BT.key == 2
    @test tree |> BT.root |> BT.left |> BT.key == 1
    @test tree |> BT.root |> BT.right |> BT.key == 5
    @test tree |> BT.root |> BT.right |> BT.left |> BT.key == 3

    # tree that accepts any types
    tree = AVLTree{Int,Any}()
    BT.insert!(tree, 2, 'A')
    BT.insert!(tree, 1, 1.1)
    BT.insert!(tree, 3, "test")
    @test BT.value(BT.search(tree, 2)) == 'A'
    @test BT.value(BT.search(tree, 1)) == 1.1
    @test BT.value(BT.search(tree, 3)) == "test"
    BT.delete!(tree, 3)
    @test !isnothing(BT.root(tree))
    @test !isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 1)
    @test !isnothing(BT.root(tree))
    @test isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 2)
    @test isnothing(BT.root(tree))

    # tree without values
    tree = AVLTree{Int}()
    BT.insert!(tree, 2)
    BT.insert!(tree, 1)
    BT.insert!(tree, 3)
    @test isnothing(BT.value(BT.search(tree, 2)))
    @test isnothing(BT.value(BT.search(tree, 1)))
    @test isnothing(BT.value(BT.search(tree, 3)))
    BT.delete!(tree, 3)
    @test !isnothing(BT.root(tree))
    @test !isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 1)
    @test !isnothing(BT.root(tree))
    @test isnothing(BT.left(BT.root(tree)))
    @test isnothing(BT.right(BT.root(tree)))
    BT.delete!(tree, 2)
    @test isnothing(BT.root(tree))

    # tree with keys that implement ordering relations
    tree = AVLTree{String,Int}()
    BT.insert!(tree, "key2", 2)
    BT.insert!(tree, "key1", 1)
    BT.insert!(tree, "key3", 3)
    @test BT.value(BT.search(tree, "key2")) == 2
    @test BT.value(BT.search(tree, "key1")) == 1
    @test BT.value(BT.search(tree, "key3")) == 3
    tree = AVLTree{NTuple{3,Int},Int}()
    BT.insert!(tree, (0, 1, 0), 2)
    BT.insert!(tree, (0, 0, 1), 1)
    BT.insert!(tree, (1, 0, 0), 3)
    @test BT.value(BT.search(tree, (0, 1, 0))) == 2
    @test BT.value(BT.search(tree, (0, 0, 1))) == 1
    @test BT.value(BT.search(tree, (1, 0, 0))) == 3

    # type stability
    tree = AVLTree{Int,Int}()
    @inferred BT.insert!(tree, 2, 20)
    @inferred BT.insert!(tree, 1, 10)
    @inferred BT.insert!(tree, 3, 30)
    @inferred Nothing BT.search(tree, 2)
    @inferred Nothing BT.search(tree, 1)
    @inferred Nothing BT.search(tree, 3)
    @inferred BT.delete!(tree, 2)
    @inferred BT.delete!(tree, 1)
    @inferred BT.delete!(tree, 3)
    tree = AVLTree{Int}()
    @inferred BT.insert!(tree, 2)
    @inferred BT.insert!(tree, 1)
    @inferred BT.insert!(tree, 3)
    @inferred Nothing BT.search(tree, 2)
    @inferred Nothing BT.search(tree, 1)
    @inferred Nothing BT.search(tree, 3)
    @inferred BT.delete!(tree, 2)
    @inferred BT.delete!(tree, 1)
    @inferred BT.delete!(tree, 3)
    tree = AVLTree{String,Int}()
    @inferred BT.insert!(tree, "key2", 2)
    @inferred BT.insert!(tree, "key1", 1)
    @inferred BT.insert!(tree, "key3", 3)
    @inferred Nothing BT.search(tree, "key2")
    @inferred Nothing BT.search(tree, "key1")
    @inferred Nothing BT.search(tree, "key3")
    @inferred BT.delete!(tree, "key2")
    @inferred BT.delete!(tree, "key1")
    @inferred BT.delete!(tree, "key3")
    tree = AVLTree{NTuple{3,Int},Int}()
    @inferred BT.insert!(tree, (0, 1, 0), 2)
    @inferred BT.insert!(tree, (0, 0, 1), 1)
    @inferred BT.insert!(tree, (1, 0, 0), 3)
    @inferred Nothing BT.search(tree, (0, 1, 0))
    @inferred Nothing BT.search(tree, (0, 0, 1))
    @inferred Nothing BT.search(tree, (1, 0, 0))
    @inferred BT.delete!(tree, (0, 1, 0))
    @inferred BT.delete!(tree, (0, 0, 1))
    @inferred BT.delete!(tree, (1, 0, 0))

    # AbstractTrees interface
    tree = AVLTree{Int,Int}()
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 5, 50)
    root = BT.root(tree)
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
    @test sprint(show, tree) == "AVLTree()"
    BT.insert!(tree, 3, 30)
    BT.insert!(tree, 2, 20)
    BT.insert!(tree, 4, 40)
    BT.insert!(tree, 1, 10)
    BT.insert!(tree, 5, 50)
    @test sprint(show, tree) == """
    AVLTree
    3 => 30
    ├─ 2 => 20
    │  └─ 1 => 10
    └─ 4 => 40
       └─ 5 => 50"""

    node = BT.search(tree, 1)
    @test sprint(show, node) == "AVLNode(1 => 10)"

    tree = AVLTree{Int}()
    BT.insert!(tree, 2)
    BT.insert!(tree, 1)
    BT.insert!(tree, 3)
    @test sprint(show, tree) == """
    AVLTree
    2
    ├─ 1
    └─ 3"""

    node = BT.search(tree, 1)
    @test sprint(show, node) == "AVLNode(1)"
  end
end
