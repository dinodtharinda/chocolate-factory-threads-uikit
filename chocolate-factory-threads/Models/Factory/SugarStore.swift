//
//  SugarFactory.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-07.
//

import Foundation

class SugarStore : Store {

    private var unitQueue: DispatchQueue
    
    private var syncQueue: DispatchQueue
    
    private var units: [Sugar] = []
    
    private var maxCapacity:Int = 480
    
    private var status: Status {
        willSet {
            DispatchQueue.main.async {[weak self] in
                self?.didChangeStatus?(newValue)
            }
        }
    }
    
    private var isActive: Bool = false
    
    private var didChangeStatus: ((Status)-> Void)?
    
    init() {
        status = .waiting
        self.unitQueue = DispatchQueue.init(
            label: "com.dinod.sugar-unit",
            attributes: .concurrent
        )
        self.syncQueue = DispatchQueue.init(label: "com.dinod.sugar-sync")
    }
    
    func setAction(didChangeStatus: @escaping (Status) -> Void){
        self.didChangeStatus = didChangeStatus
    }
    
    func start(){
        syncQueue.async {
            // enable isActive
            self.isActive = true
        
            self.unitQueue.async{ [weak self] in
                guard let `self` = self else { return }
                // check free space
                
                var isActive = syncQueue.sync{
                    self.isActive
                }
                
                // loop produce
                while isActive {
                    if(self.maxCapacity >= self.units.count){
                        syncQueue.sync {
                            self.status = .producing
                        }
                        Thread.sleep(forTimeInterval: 0.2)
                        units.insert(Sugar(), at: 0)
                        print("Sugar Produced")
                     
                    } else {
                        let st = self.syncQueue.sync{
                            self.status
                        }
                        
                        if(st != .resourceFull){
                            syncQueue.sync {
                                self.status = .resourceFull
                            }
                        }
                    }
                    
                    isActive = syncQueue.sync{
                        self.isActive
                    }
                }
            }
        }
        

    }
    
    func pause() {
        syncQueue.async {
            self.isActive = false
        }
    }
    
    
    func reset(){
        syncQueue.async {
            self.isActive = false
            self.status = .stopped
            self.unitQueue.async {
                print("Reset")
                self.units = []
            }
        }
    }
    
    func consume(count:Int,callback: @escaping ([Sugar]?) -> Void ){
        // check stock availability
        guard count <=  units.count else {
            callback(nil)
            return
        }
        var output: [Sugar] = []
    
        unitQueue.async { [weak self] in
           
            guard let `self` = self else {
                callback(nil)
                return
            }
            
            for _ in (0..<count).reversed() {
                guard let last = units.popLast() else {
                    callback(output)
                    break
                }
                output.append(last)
            }
           
            
            callback(output)
        }
    }
    
    
}

