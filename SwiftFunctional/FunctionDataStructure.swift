//
//  FunctionDataStructure.swift
//  SwiftFunctional
//
//  Created by 常仲伟 on 2021/11/14.
//

import Foundation

struct MySet<Element: Equatable> {
  var storage: [Element] = []
  var isEmpty: Bool { return storage.isEmpty }
  
  func contains(_ element: Element) -> Bool {
    return storage.contains(element)
  }
  
  func inserting(_ x: Element) -> MySet {
    return contains(x) ? self : MySet(storage: storage + [x])
  }
}

/*
 这个定义规定了每⼀棵树，要么是：
  → ⼀个没有关联值的叶⼦ leaf，要么是
  → ⼀个带有三个关联值的节点 node，关联值分别是左⼦树，储存在该节点的值和右⼦树。
 */
indirect enum BinarySearchTree<Element: Comparable> {
  case leaf
  case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

fileprivate func test0() {
  let leaf: BinarySearchTree<Int> = .leaf
  let five: BinarySearchTree<Int> = .node(leaf, 5, leaf)
}

fileprivate
extension BinarySearchTree {
  init() {
    self = .leaf
  }
  
  init(_ value: Element) {
    self = .node(.leaf, value, .leaf)
  }
  
  var count: Int {
    switch self {
      case .leaf:
        return 0
      case let .node(left, _, right):
        return 1 + left.count + right.count }
  }
  
  var elements: [Element] {
    switch self {
      case .leaf:
        return []
      case let .node(left, x, right):
        return left.elements + [x] + right.elements }
  }
//将递归地调⽤⼦节点，然后将结果与当前节点中的元素合并起来
  func reduce<A>(leaf leafF: A, node nodeF: (A, Element, A) -> A) -> A {
    switch self {
      case .leaf:
        return leafF
      case let .node(left, x, right):
        return nodeF(left.reduce(leaf: leafF, node: nodeF), x, right.reduce(leaf: leafF, node: nodeF)) }
  }
  
  var elementsR: [Element] {
    return reduce(leaf: []) { $0 + [$1] + $2 }
  }
  
  var countR: Int {
    return reduce(leaf: 0) { 1 + $0 + $2 }
  }
  
  var isEmpty: Bool {
    if case .leaf = self {
      return true
    }
    return false
  }
  
  /*
   如果为这个结构加上⼀个⼆叉搜索树的限制，问题就会迎刃⽽解。
   如果⼀棵 (⾮空) 树符合以下⼏点，就可以被视为⼀棵⼆叉搜索树：
     → 所有储存在左⼦树的值都⼩于其根节点的值
     → 所有储存在右⼦树的值都⼤于其根节点的值
     → 其左右⼦树都是⼆叉搜索树
   */
  
  var isBST: Bool {
    switch self {
      case .leaf: return true
      case let .node(left, x, right):
        return left.elements.all { y in y < x }
          && right.elements.all { y in y > x }
          && left.isBST
          && right.isBST
    }
  }
  
  func contains(_ x: Element) -> Bool {
    switch self {
      case .leaf:
        return false
      case let .node(_, y, _) where x == y:
        return true
      case let .node(left, y, _) where x < y:
        return left.contains(x)
      case let .node(_, y, right) where x > y:
        return right.contains(x)
      default:
        fatalError("The impossible occurred") }
  }
  
  mutating func insert(_ x: Element) {
    switch self {
      case .leaf:
        self = BinarySearchTree(x)
      case .node(var left, let y, var right):
        if x < y { left.insert(x) }
        if x > y { right.insert(x) }
        self = .node(left, y, right)
    }
  }
}

fileprivate
extension Sequence{
  func all(predicate: (Iterator.Element) -> Bool) -> Bool {
    for x in self where !predicate(x) {
      return false
    }
    return true
  }
}
