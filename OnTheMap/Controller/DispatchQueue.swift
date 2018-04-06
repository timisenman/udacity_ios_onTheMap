//
//  DispatchQueue.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/3/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
