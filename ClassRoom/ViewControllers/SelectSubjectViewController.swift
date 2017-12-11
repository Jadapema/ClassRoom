//
//  SelectSubjectViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 9/9/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class SelectSubjectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Search: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var Segmented: UISegmentedControl!
    
    var Subjects : [Subject]  = []

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //subjectsCamera
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Creamos tantas filas como elementos existan en la base de datos
        return Subjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creamos una TableViewCell con el Identificador que  le dimos a nuestro modelo
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectsCamera", for: indexPath) as! SubjectsTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.479084909, blue: 0.6649822593, alpha: 1)
        cell.BGView.backgroundColor = #colorLiteral(red: 0, green: 0.2684682608, blue: 0.4762560725, alpha: 1)
        cell.BGView.layer.cornerRadius = 10
        cell.BGView.layer.masksToBounds = false
        cell.BGView.clipsToBounds = true
            //Asignamos cada valor a los textos de nuestras celdas
        cell.SubjectName.text = Subjects[indexPath.row].Name
        cell.UniversityName.text = Subjects[indexPath.row].University.Name
        cell.Year.text = "\(Subjects[indexPath.row].Year!)"
        cell.GroupCount.text = "Grupos: \(Subjects[indexPath.row].Groups.count)"
            
        
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Subjec Selected: \(Subjects[indexPath.row].SubId!)")
        UserDefaults.standard.set(Subjects[indexPath.row].SubId, forKey: "SUBID")
        dismiss(animated: true, completion: nil)
        
        return indexPath
    }
    
}
