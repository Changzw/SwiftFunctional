//
//  Battleship.swift
//  SwiftFunctional
//
//  Created by 常仲伟 on 2021/11/14.
//

import Foundation

typealias Distance = Double
typealias Region = (Position) -> Bool// Region 类型将指代把 Position 转化为 Bool 的函数。
/*
func pointInRange(point: Position) -> Bool { // 方法的具体实现
  true
}
*/
func circle(radius: Distance) -> Region {
//  return { point in point.length <= radius }
  { $0.length <= radius }
}

func circle2(radius: Distance, center: Position) -> Region {
  return { point in point.minus(center).length <= radius }
}

/*
 如果我们想对更多的图形组件 (例如，想象我们不仅有圆，还有矩形或其它形状) 做出同样的改变，可能需要重复这些代码。
 更加函数式的⽅式是写⼀个区域变换函数。这个函数按⼀定的偏移量移动⼀个区域：
 */
func shift(_ region: @escaping Region, by offset: Position) -> Region {// 柯里化
  return { point in
    region(point.minus(offset))
  }
}

//circle2(radius: 10, center: Position(x: 5, 5))
let shifted = shift(circle(radius: 10), by: Position(x: 5, y: 5))

func invert(_ region: @escaping Region) -> Region {
  return { point in !region(point) }
}

func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
  return { point in
    region(point) && other(point)
  }
}

func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
  return { point in
    region(point) || other(point)
  }
}

func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
  return intersect(original, with: invert(region))
}

struct Position {
  var x: Double
  var y: Double
}

extension Position {// 以 (0,0) 为圆心
  var length: Distance {
    sqrt(x * x + y * y)
  }
  
  func within(range: Distance) -> Bool {
    sqrt(x * x + y * y) <= range
  }
  func minus(_ p: Position) -> Position {
    return Position(x: x - p.x, y: y - p.y)
  }
}

struct Ship {
  var position: Position
  var firingRange: Distance//射程范围
  var unsafeRange: Distance//避免与过近的敌方船舶交战
}

extension Ship {
  func canEngage(ship target: Ship) -> Bool {
    let dx = target.position.x - position.x
    let dy = target.position.y - position.y
    let targetDistance = sqrt(dx * dx + dy * dy)
    return targetDistance <= firingRange
  }
  
  func canSafelyEngage(ship target: Ship) -> Bool {
    let dx = target.position.x - position.x
    let dy = target.position.y - position.y
    let targetDistance = sqrt(dx * dx + dy * dy)
    return targetDistance <= firingRange && targetDistance > unsafeRange
  }
  
  func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
    let targetDistance = target.position.minus(position).length
    let friendlyDistance = friendly.position.minus(target.position).length
    return targetDistance <= firingRange
      && targetDistance > unsafeRange
      && (friendlyDistance > unsafeRange)
  }
  
  func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
    let dx = target.position.x - position.x
    let dy = target.position.y - position.y
    let targetDistance = sqrt(dx * dx + dy * dy)
    let friendlyDx = friendly.position.x - target.position.x
    let friendlyDy = friendly.position.y - target.position.y
    let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
    
    return targetDistance <= firingRange
      && targetDistance > unsafeRange
      && (friendlyDistance > unsafeRange)
  }
  
  func canSafelyEngage3(ship target: Ship, friendly: Ship) -> Bool {
    let rangeRegion     = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
    let firingRegion    = shift(rangeRegion, by: position)
    let friendlyRegion  = shift(circle(radius: unsafeRange), by: friendly.position)
    let resultRegion    = subtract(friendlyRegion, from: firingRegion)
    
    return resultRegion(target.position)
  }
}

/*
 Region 类型的⽅法有它⾃⾝的缺点。
 我们选择了将 Region 类型定义为简单类型，并作为 (Position) -> Bool 函数的别名。
 其实，我们也可以选择将其定义为⼀个包含单⼀函数的结构体：
 
 struct Region {
   let lookup: (Position) -> Bool
 }

 接下来我们可以⽤ extensions 的⽅式为结构体定义⼀些类似的⽅法，来代替对原来的 Region 类型进⾏操作的⾃由函数。
 这可以让我们能够通过对区域进⾏反复的函数调⽤来变换这个区域，直⾄得到需要的复杂区域，⽽不⽤像以前那样将区域作为参数传递给其他函数：
 rangeRegion
  .shift(ownPosition)
  .difference(friendlyRegion)
 
 这种⽅法有⼀个优点，它需要的括号更少。再者，这种⽅式下 Xcode 的⾃动补全在装配复杂的 区域时会⼗分有⽤。不过，为了便于展⽰，我们选择了使⽤简单的 typealias 以突出在 Swift 中 使⽤⾼阶函数的⽅法。
 */
