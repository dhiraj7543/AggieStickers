//
//  DropdownView.swift
//  InspectExpert
//
//  Created by Vakul Saini on 09/05/19.
//  Copyright © 2019 enAct eServices. All rights reserved.
//

import UIKit

protocol DropdownViewDelegate: NSObjectProtocol {
    func dropDown(_ dropdown: DropdownView, didSelectItem item: String, atIndex index: Int)
}

public enum DropdownPosition {
    case Top
    case Bottom
}

public class DropdownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    weak var delegate: DropdownViewDelegate?
    
    fileprivate var position: DropdownPosition = .Bottom
    
    var items: [String] = [] {
        didSet {
            self.tblView.reloadData()
            self.updateHeight(true)
        }
    }
    
    static let ROW_HEIGHT: CGFloat = 40.0
    static let MAX_ROWS = 4
    
    static let shared: DropdownView = DropdownView.view()
    
    static func view() -> DropdownView {
        let outlets = Bundle.main.loadNibNamed("DropdownView", owner: self, options: nil)
        var obj: DropdownView?
        for outlet in outlets ?? [] {
            if let out = outlet as? DropdownView {
                obj = out
                obj?.tblView.register(UINib(nibName: "DropdownCell", bundle: nil), forCellReuseIdentifier: "DropdownCell")
                obj?.tblView.delegate = obj
                obj?.tblView.dataSource = obj
                obj?.tblView.separatorStyle = .none
                break
            }
        }
        return obj!
    }
    
    // MARK:- TableView Delegates & DataSources
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        cell.selectionStyle = .none
        cell.item =  items[indexPath.row]//items[indexPath.row].name
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DropdownView.ROW_HEIGHT
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
        self.delegate?.dropDown(self, didSelectItem: items[indexPath.row] , atIndex: indexPath.row)
    }
    
    // MARK:- Methods
    func showFor(source: UIView, atPosition position: DropdownPosition) {
        if let window = UIApplication.shared.keyWindow {
            showFor(source: source, onView: window, atPosition: position)
        }
    }
    
    func showFor(source: UIView, onView view: UIView, atPosition position: DropdownPosition) {
        
        if self.superview != nil {
            /// Already added first hide it
            hide()
            return
        }
        
        self.position = position
        self.tblView.reloadData()
        let point = source.convert(CGPoint.zero, to: view)
        
        var y: CGFloat = (point.y + source.frame.size.height) + 3.0
        if position == .Top {
            y = point.y - 3.0
        }
        //width  = source.frame.size.width + 60
        let frame = CGRect(x: point.x, y: y, width: 220, height: 0.0)
        self.frame = frame
        view.addSubview(self)
        updateHeight(true)
    }
    
    func hide() {
        
        /// Check if not added on any view
        if self.superview == nil {return}
        
        var frame = self.frame
        if position == .Bottom {
            frame.size.height = 0.0
        }
        else {
            frame.origin.y += frame.size.height
            frame.size.height = 0.0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = frame
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    fileprivate func updateHeight(_ animated: Bool) {
        
        /// Check if not added on any view
        if self.superview == nil {return}
        
        let height = min(CGFloat(DropdownView.MAX_ROWS) * DropdownView.ROW_HEIGHT, CGFloat(items.count) * DropdownView.ROW_HEIGHT)
        
        /// Check if already same height
        if self.frame.size.height == height {return}
        
        var frame = self.frame
        if position == .Bottom {
            frame.size.height = height
        }
        else {
            frame.origin.y -= height
            frame.size.height = height
        }

        /// If frame need to change without animation
        if !animated {
            self.frame = frame
            return
        }

        UIView.animate(withDuration: 0.3) {
            self.frame = frame
        }
    }
}

public class DropdownCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    var item: String = "" {
        didSet {
            label.text = item
        }
    }
}
