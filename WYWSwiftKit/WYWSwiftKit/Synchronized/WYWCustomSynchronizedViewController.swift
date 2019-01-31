//
//  WYWCustomSynchronizedViewController.swift
//  WYWSwiftKit
//
//  Created by wangyongwang on 2019/1/30.
//  Copyright © 2019年 it.wyw. All rights reserved.
// https://swift.gg/2018/07/30/friday-qa-2015-02-20-lets-build-synchronized/
// https://www.mikeash.com/pyblog/friday-qa-2015-02-20-lets-build-synchronized.html

import UIKit

class WYWCustomSynchronizedViewController: UIViewController {

    let locksTable = NSMapTable<AnyObject, AnyObject>.weakToWeakObjects()
    var locksTableLock = OS_SPINLOCK_INIT;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ticketLockObj = NSObject()
        var ticketCount = 20;
        
        for index in 1...ticketCount {
            DispatchQueue.global().async {
                self.wywSynchronized(obj: ticketLockObj, closure: {
                    ticketCount = ticketCount - 1
                    print("剩余票数:\(ticketCount) 所卖票索引:\(index) ")
                })
            }
        }
    }
    
    func wywSynchronized(obj: AnyObject, closure: () -> Void) {
        // 当前下述方法在iOS10时已废弃
        // 新方法： os_unfair_lock_lock
        OSSpinLockLock(&locksTableLock)
        var lock = locksTable.object(forKey: obj) as! NSRecursiveLock?
        if lock == nil {
            lock = NSRecursiveLock()
            locksTable.setObject(lock, forKey: obj)
        }
        OSSpinLockUnlock(&locksTableLock);
        
        lock?.lock()
        closure()
        lock?.unlock()
    }
}

/**
 输出结果：
 
 剩余票数:19 所卖票索引:1
 剩余票数:18 所卖票索引:2
 剩余票数:17 所卖票索引:4
 剩余票数:16 所卖票索引:5
 剩余票数:15 所卖票索引:6
 剩余票数:14 所卖票索引:7
 剩余票数:13 所卖票索引:8
 剩余票数:12 所卖票索引:9
 剩余票数:11 所卖票索引:10
 剩余票数:10 所卖票索引:11
 剩余票数:9 所卖票索引:12
 剩余票数:8 所卖票索引:13
 剩余票数:7 所卖票索引:14
 剩余票数:6 所卖票索引:15
 剩余票数:5 所卖票索引:16
 剩余票数:4 所卖票索引:3
 剩余票数:3 所卖票索引:17
 剩余票数:2 所卖票索引:19
 剩余票数:1 所卖票索引:18
 剩余票数:0 所卖票索引:20
 
 */
