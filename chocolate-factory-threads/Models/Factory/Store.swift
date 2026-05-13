//
//  Store.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-11.
//

import Foundation


protocol Store {
    func setAction(didChangeStatus: @escaping (Status) -> Void)
}
