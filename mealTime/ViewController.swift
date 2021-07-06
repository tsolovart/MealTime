//
//  ViewController.swift
//  mealTime
//
//  Created by Zaoksky on 06.07.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.roundCornerView(corners: [.bottomLeft, .topLeft], radius: imageView.frame.size.height/2)
    }

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
    }
    
}

extension UIView {
    // функция закругления углов
    func roundCornerView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

