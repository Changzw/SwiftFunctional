//
//  OptionalValue.swift
//  SwiftFunctional
//
//  Created by 常仲伟 on 2021/11/14.
//

import Foundation

infix operator ??

fileprivate
func ??<T>(optional: T?, defaultValue: T) -> T {
  if let x = optional {
    return x
  } else {
    return defaultValue
  }
}

fileprivate
func test0() {
  let cache = ["test.swift": 1000]
  let defaultValue = 2000 // 本地读取
//  cache["hello.swift"] ?? defaultValue
}

//上⾯的定义有⼀个问题：如果 defaultValue 的值是通过某个函数或者表达式计算得到的，那么 ⽆论可选值是否为 nil，defaultValue 都会被求值。通常我们并不希望这种情况发⽣：⼀个 if-then-else 语句应该根据各分⽀关联的值是否为真，只执⾏其中⼀个分⽀。这种⾏为有时候 被称为短路，与 || and && 的⼯作原理相似。
//我们真的不愿意对 defaultValue 进⾏求值 —— 因 为这可能是⼀个开销⾮常⼤的计算，只有绝对必要时我们才会想运⾏这段代码。可以按如下⽅ 式解决这个问题：
fileprivate
func ??<T>(optional: T?, defaultValue: () -> T) -> T {
  if let x = optional {
    return x
  } else {
    return defaultValue()
  }
}

fileprivate
var a: Int? = 10
fileprivate
func test() {
  print(a ?? { 100 })
}

fileprivate
func ??<T>(optional: T?, defaultValue: @autoclosure () throws -> T) rethrows -> T {
  if let x = optional {
    return x
  } else {
    return try defaultValue()
  }
}
