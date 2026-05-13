//
//  ViewController.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-04-30.
//

import UIKit

class ViewController: UIViewController {

//    @IBOutlet private weak var vStackThreadsList: UIStackView!
    @IBOutlet private weak var milkThreadStatus: ThreadStatusCard!
    @IBOutlet weak var cocoaThreadStatus: ThreadStatusCard!
    @IBOutlet weak var sugarThreadStatus: ThreadStatusCard!
    @IBOutlet weak var chocoThreadStatus: ThreadStatusCard!
    @IBOutlet weak var giftThreadStatus: ThreadStatusCard!
    var viewModel: ChocoFactoryViewModel = .init()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThreadStatusCard()
        
    }
    
    func setupThreadStatusCard(){
        milkThreadStatus
            .setup(
                model: ThreadStatus(
                    threadName: "Milk Thread",
                    threadStatus: .waiting,
                    store: viewModel.milkFactory
                )
            )
        cocoaThreadStatus
            .setup(
                model: ThreadStatus(
                    threadName: "Cocoa Thread",
                    threadStatus: .waiting,
                    store: viewModel.cocoaFactory
                )
            )
        
        sugarThreadStatus
            .setup(
                model: ThreadStatus(
                    threadName: "Sugar Thread",
                    threadStatus: .waiting,
                    store: viewModel.sugarFactory
                )
            )
        
        chocoThreadStatus
            .setup(
                model: ThreadStatus(
                    threadName: "Choco Thread",
                    threadStatus: .waiting,
                    store: viewModel.chocoFactory
                )
            )
        
        giftThreadStatus
            .setup(
                model: ThreadStatus(
                    threadName: "Gift Thread",
                    threadStatus: .waiting,
                    store: viewModel.giftFactory
                )
            )
        
        
       
        
    }
    
    

    @IBAction func btnReset(_ sender: Any) {
        print("Reset Clicked")
        viewModel.reset()
    }
    @IBAction func btnStart(_ sender: Any) {
        print("Start Clicked")
        viewModel.start()
    }
    @IBAction func btnPause(_ sender: Any) {
        print("Pause Clicked")
        viewModel.pause()
    }

}

