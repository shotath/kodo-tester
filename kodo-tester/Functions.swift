//
//  Functions.swift
//  kodo-tester
//
//  Created by shota_th on 2015/08/08.
//  Copyright (c) 2015年 s.kurihara. All rights reserved.
//

import UIKit

func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

