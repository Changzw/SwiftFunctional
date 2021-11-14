//
//  GeneralFunction.swift
//  SwiftFunctional
//
//  Created by 常仲伟 on 2021/11/14.
//

import Foundation

func increment(array: [Int]) -> [Int] {
  var result: [Int] = []
  for x in array {
    result.append(x + 1)
  }
  return result
}

func double(array: [Int]) -> [Int] {
  var result: [Int] = []
  for x in array {
    result.append(x * 2)
  }
  return result
}
func compute<Int>(array: [Int], transform: (Int) -> Int) -> [Int] {
  var result: [Int] = []
  for x in array {
    result.append(transform(x))
  }
  return result
}

func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
  var result: [T] = []
  for x in array {
    result.append(transform(x))
  }
  return result
}

func double2(array: [Int]) -> [Int] {
  return compute(array: array) { $0 * 2 }
}

func isEven(array: [Int]) -> [Bool] {
  return genericCompute(array: array) {
    $0 % 2 == 0
  }
}

func getSwiftFiles(in files: [String]) -> [String] {
  var result: [String] = []
  for file in files {
    if file.hasSuffix(".swift") {
      result.append(file)
    }
    
  }
  return result
}

func sum(integers: [Int]) -> Int {
  var result: Int = 0
  for x in integers { result += x }
  return result
}

func product(integers: [Int]) -> Int {
  var result: Int = 1
  for x in integers {
    result = x * result
  }
  return result
}

func concatenate(strings: [String]) -> String {
  var result: String = ""
  for string in strings {
    result += string
  }
  return result
}
func prettyPrint(strings: [String]) -> String {
  var result: String = "Entries in the array xs:\n"
  for string in strings {
    result = " " + result + string + "\n"
  }
  return result
}

func flatten<T>(_ xss: [[T]]) -> [T] {
  var result: [T] = []
  for xs in xss { result += xs }
  return result
}

func flattenUsingReduce<T>(_ xss: [[T]]) -> [T] {
  return xss.reduce([]) {
    result, xs in result + xs
  }
}

// 之前的函数式编程都是把 Array 当做数组，现在把这个方法放到 Array 的扩展中，这样就解决输入问题了
// 函数式依赖 结构化编程的时候，可以减少输入参数——> 而这个输入参数多半是函数式编程中的值类型！
extension Array {
  func map<T>(_ transform: (Element) -> T) -> [T] {
    var result: [T] = []
    for x in self {
      result.append(transform(x))
    }
    return result
  }
  
  func filter(_ includeElement: (Element) -> Bool) -> [Element] {
    var result: [Element] = []
    for x in self where includeElement(x) {
      result.append(x)
    }
    return result
  }
  
  func reduce<T>(_ initial: T, combine: (T, Element) -> T) -> T {
    var result = initial
    for x in self {
      result = combine(result, x)
    }
    return result
  }
  
  func mapUsingReduce<T>(_ transform: (Element) -> T) -> [T] {
    return reduce([]) { result, x in
      return result + [transform(x)]
    }
  }
  
  func filterUsingReduce(_ includeElement: (Element) -> Bool) -> [Element] {
    return reduce([]) { result, x in
      return includeElement(x) ? result + [x] : result
    }
  }
}

