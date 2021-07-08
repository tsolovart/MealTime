//
//  ViewController.swift
//  mealTime
//
//  Created by Zaoksky on 06.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource  {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var array = [Date]()
    var person: Person!
    
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
        
        // путь до контекста NSPersistentContainer
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // проверка наличия значений Person в CoreData
        let personName = "Artem"
        // запрос на данные
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", personName)
        
        // попытка на выполнение запроса
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                person = Person(context: context)
                person.name = personName
                try context.save()
            } else {
                person = results.first
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    // заголовок секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My meal time"
    }
    
    // кол-во рядов = кол-ву элементов в массиве
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //если meals = nil, то возвращаем один ряд
        guard let meals = person.meals else { return 1 }
        return meals.count
    }
    
    // ячейка = время
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        // конкретный прием прищи помещается в meal, если он есть
        // извлечение даты
        guard let meal = person.meals?[indexPath.row] as? Meal, let mealDate = meal.date else { return cell! }
        cell!.textLabel!.text = dateFormatter.string(from: mealDate)
        return cell!
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        
        // путь до контекста NSPersistentContainer
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let meal = Meal(context: context)
        meal.date = Date()
        
        // копия Person - meals NSOrderedSet (не изменяемый) и замена на NSMutableOrderedSet
        let meals = person.meals?.mutableCopy() as? NSMutableOrderedSet
        meals?.add(meal)
        person.meals = meals
        
        do {
            try context.save()
            print("Save context")
        } catch let error as NSError {
            print("Error: \(error), userInfo \(error.userInfo)")
        }
        
        // перезагрузка таблицы
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

