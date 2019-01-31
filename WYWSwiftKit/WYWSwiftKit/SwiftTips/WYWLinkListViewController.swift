//
//  WYWLinkListViewController.swift
//  WYWSwiftKit
//
//  Created by wangyongwang on 2019/1/31.
//  Copyright © 2019年 it.wyw. All rights reserved.
// 学习网址：https://swifter.tips/indirect-nested-enum/

import UIKit

class Node<T> {
    let value: T?
    let next: Node<T>?
    
    init(value: T?, next: Node<T>?) {
        self.value = value
        self.next = next
    }
}

indirect enum LinkedList<Element: Comparable> {
    case empty
    case node(Element, LinkedList<Element>)
    
    func removing(_ element: Element) -> LinkedList<Element> {
        guard case let .node(value, next) = self else {
            return .empty
        }
        
        return value == element ? next : LinkedList.node(value, next.removing(element))
    }
}



/// 链表
class WYWLinkListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let list = Node(value:1,
                        next: Node(value: 2,
                        next: Node(value: 3,
                        next: Node(value:4,
                        next:nil))))
        print("\(list)\n")
        
        let linkedList = LinkedList.node(1,
                                    .node(2,
                                     .node(3,
                                     .node(4,
                                     .empty))))
        print("\(linkedList)\n")
        
        let result = linkedList.removing(2)
        
        print("\(result)")
    }
}

/**
 输出结果：
 WYWSwiftKit.Node<Swift.Int>
 
 node(1, WYWSwiftKit.LinkedList<Swift.Int>.node(2, WYWSwiftKit.LinkedList<Swift.Int>.node(3, WYWSwiftKit.LinkedList<Swift.Int>.node(4, WYWSwiftKit.LinkedList<Swift.Int>.empty))))
 
 node(1, WYWSwiftKit.LinkedList<Swift.Int>.node(3, WYWSwiftKit.LinkedList<Swift.Int>.node(4, WYWSwiftKit.LinkedList<Swift.Int>.empty)))
 */
