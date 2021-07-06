//
//  ViewController.swift
//  mealTime
//
//  Created by Zaoksky on 06.07.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var array = [Date]()
    
    // корректное отображение даты и времени
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.roundCornerView(corners: [.bottomLeft, .topLeft], radius: imageView.frame.size.height/2)
        
        // регистрация класса для ячеек
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // заголовок секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My meal time"
    }
    
    // кол-во рядов = кол-ву элементов в массиве
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    // ячейка = время
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let date = array[indexPath.row]
        // конкретный прием прищи помещается в meal, если он есть
        // извлечение даты
        //guard let meal = person.meals?[indexPath.row] as? Meal, let mealDate = meal.date else { return cell! }
        cell!.textLabel!.text = dateFormatter.string(from: date)
        return cell!
    }

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let date = Date()
        array.append(date)
        tableView.reloadData()
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

