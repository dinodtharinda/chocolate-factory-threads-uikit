//
//  AppUIView.swift
//  Keyboard
//
//  Created by Prashan Samarathunge on 2023-08-22.
//  Copyright © 2023 Bhasha. All rights reserved.
//

import Foundation
import UIKit

public class AppUIView:UIView{
    
    static var nibName: String { return String(describing: self) }
    
    open var useConstraints: Bool{
        get{
            return true
        }
    }
    
    internal weak var view: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews(){
        let vw = loadViewFromNib()
        self.frame = bounds
        vw.tag = 9898
        if useConstraints{
            addSubview(vw)
            vw.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vw.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                vw.topAnchor.constraint(equalTo: self.topAnchor),
                vw.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                vw.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }else{
            vw.autoresizingMask = [.flexibleWidth,
                                   .flexibleHeight,
            ]
            addSubview(vw)
        }
        self.view = vw
        viewDidLoad()
    }
    
    func viewDidLoad(){
        
    }
    
    private func loadViewFromNib() -> UIView{
        let nib = UINib(nibName: Self.nibName, bundle: nil)
        let lv = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return lv
    }
}

protocol AppTableViewHeaderFooter  where Self:UITableViewHeaderFooterView {
    associatedtype CellModel
    
    static var identifier: String { get }
    static func register(inTableView: UITableView)
    static func dequeue(from tableView: UITableView, _ data: CellModel?) -> UITableViewHeaderFooterView
    func initialize(_ model: CellModel?)
}

extension AppTableViewHeaderFooter where Self:UITableViewHeaderFooterView {
    
    static var identifier: String { return String(describing: self) }
    
    
    static func register(inTableView: UITableView) {
        let nib = UINib(nibName: identifier, bundle: nil)
        inTableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    static func dequeue(from tableView: UITableView, _ data: CellModel?) -> UITableViewHeaderFooterView{
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else{fatalError("Dequeue Failed")}
        let cast = header as! Self
        cast.initialize(data)
        return header
    }
    
}
