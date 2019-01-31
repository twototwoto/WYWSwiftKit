//
//  WYWSynchronizedViewController.swift
//  WYWSwiftKit
//
//  Created by wangyongwang on 2019/1/30.
//  Copyright © 2019年 it.wyw. All rights reserved.
// 学习网址：https://swifter.tips/lock/
// 实现原理：https://opensource.apple.com/source/objc4/objc4-646/runtime/objc-sync.mm.auto.html

import UIKit

/// Swift 自定义@Synchronized
class WYWSynchronizedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ticketLockObj = NSObject()
        var ticketCount = 20;
        for index in 1...ticketCount {
            DispatchQueue.global().async {
                self.wywEnterLeaveSynchronized(lockObj: ticketLockObj, closure: {
                    ticketCount = ticketCount - 1
                    print("剩余票数:\(ticketCount) 所卖票索引:\(index) ")
                })
            }
        }
    }
    
    /// 自定义@synchronized()
    func wywEnterLeaveSynchronized(lockObj: AnyObject, closure: ()->Void) {
        objc_sync_enter(lockObj);
        closure();
        objc_sync_exit(lockObj);
    }
}


/**
 * 输出结果如下：
 
 剩余票数:19 所卖票索引:1
 剩余票数:18 所卖票索引:2
 剩余票数:17 所卖票索引:3
 剩余票数:16 所卖票索引:4
 剩余票数:15 所卖票索引:5
 剩余票数:14 所卖票索引:6
 剩余票数:13 所卖票索引:7
 剩余票数:12 所卖票索引:8
 剩余票数:11 所卖票索引:9
 剩余票数:10 所卖票索引:10
 剩余票数:9 所卖票索引:11
 剩余票数:8 所卖票索引:12
 剩余票数:7 所卖票索引:13
 剩余票数:6 所卖票索引:14
 剩余票数:5 所卖票索引:15
 剩余票数:4 所卖票索引:16
 剩余票数:3 所卖票索引:17
 剩余票数:2 所卖票索引:18
 剩余票数:1 所卖票索引:19
 剩余票数:0 所卖票索引:20
 
 */

/**
 
 相关内容：
 * https://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized
 * https://stackoverflow.com/questions/49160125/thread-safe-singleton-in-swift
 * https://objccn.io/issue-2-4/
 */
