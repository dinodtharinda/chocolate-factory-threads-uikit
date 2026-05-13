//
//  ChocoFactoryViewModel.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-05-04.
//

import Foundation
import UIKit

class ChocoFactoryViewModel {
    var milkFactory: MilkStore
    var sugarFactory: SugarStore
    var cocoaFactory: CocoaStore
    var chocoFactory: ChocoStore
    var giftFactory: GiftStore
    
    
    var queue : DispatchQueue
    
    init() {
        self.milkFactory = MilkStore()
        self.sugarFactory = SugarStore()
        self.cocoaFactory = CocoaStore()
        self.chocoFactory = ChocoStore()
        self.giftFactory = GiftStore()
        self.queue = .init(label: "viewmodel.queue", attributes: .concurrent)
        chocoFactory.setCallbacks(callbackConsumeMilk: milkConsume)

    }
    
    
    
    func milkConsume() -> Milk?{
        var milk: Milk?
        
        queue.sync {
            self.milkFactory.consume(callback: { output in
                guard let m = output else {
                    return
                }
                
                milk = m
            })
           
        }
        
        return milk
    }
    

   
    func start(){
        queue.async{
            self.milkFactory.start()
          
        }
        
        queue.async{
            self.chocoFactory.startProduction()
        }
       
//        sugarFactory.start()
//        cocoaFactory.start()
//        giftFactory.produce(chocoStore: chocoFactory, milkStore: milkFactory)
    }
    
    func pause(){
        milkFactory.pause()
        sugarFactory.pause()
        cocoaFactory.pause()
    }
    
    
    func reset(){
        milkFactory.reset()
        sugarFactory.reset()
        cocoaFactory.reset()
    }
    
    
    func callBack(units:[any Raw]?){
        guard let u = units else {
            print("nil")
            return
        }
        
        for i in u {
            print(i)
        }
    }
}
