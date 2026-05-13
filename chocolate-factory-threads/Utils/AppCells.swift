//
//  AppTableViewCell.swift
//  HostingApp
//
//  Created by Prashan Samarathunge on 2023-03-09.
//  Copyright © 2023 Bhasha. All rights reserved.
//

import Foundation
import UIKit


protocol AppTableViewCell where Self:UITableViewCell {
    associatedtype CellModel
    
    static var identifier: String { get }
    static func register(inTableView: UITableView)
    static func dequeue(from tableView: UITableView, _ data: CellModel?) -> UITableViewCell
    func initialize(_ model: CellModel?)
}

extension AppTableViewCell where Self:UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    
    static func register(inTableView: UITableView) {
        let nib = UINib(nibName: identifier, bundle: nil)
        inTableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    
    
    static func dequeue(from tableView: UITableView, _ data: CellModel? = nil) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else{fatalError("Dequeue Failed")}
        
        let cast = cell as! Self
        cast.initialize(data)
        return cell
    }
    
    func initialize(_ model: CellModel? = nil){}
}

//MARK: CollectionViewCell
protocol AppCollectionViewCell where Self:UICollectionViewCell{
    associatedtype CellModel
    static var identifier: String { get }
    static func register(inCollectionView: UICollectionView)
    static func dequeue(from collectionView: UICollectionView, at: IndexPath, _ data: CellModel?) -> UICollectionViewCell
    func initialize(_ model: CellModel?)
}

extension AppCollectionViewCell where Self:UICollectionViewCell{
    
    static var identifier: String { return String(describing: self) }
    
    static func register(inCollectionView: UICollectionView){
        let nib = UINib(nibName: identifier, bundle: nil)
        inCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    static func dequeue(from collectionView: UICollectionView, at: IndexPath, _ data: CellModel? = nil) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: at)
        let cast = cell as! Self
        cast.initialize(data)
        return cell
    }
    
    func initialize(_ model: CellModel? = nil){}
}
