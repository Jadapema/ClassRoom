//
//  CategoriesViewController.swift
//  ClassRoom
//
//  Created by Jacob Peralta on 23/10/17.
//  Copyright © 2017 Jadapema. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    
    @IBOutlet var Back: UIImageView!
    @IBOutlet var CategoriesTableView: UITableView!
    
    var selectedCategory : String!
    var selectedCategoryFB : String!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        CategoriesTableView.delegate = self
        CategoriesTableView.dataSource = self
        
        Back.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BackHandle)))
        Back.isUserInteractionEnabled = true
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoriesTableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath) as! CategoryTableViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.1491528427, blue: 0.2637124495, alpha: 1)
        if indexPath.row == 0 {
            cell.Category.text = "Informatica"
            cell.Cover.image = #imageLiteral(resourceName: "informatica")
            return cell
        } else if indexPath.row == 1 {
            cell.Category.text = "Novelas"
            cell.Cover.image = #imageLiteral(resourceName: "novelas")
            return cell
        } else if indexPath.row == 2 {
            cell.Category.text = "Ciencia Ficcion"
            cell.Cover.image = #imageLiteral(resourceName: "ciencia ficcion")
            return cell
        } else if indexPath.row == 3 {
            cell.Category.text = "Biografias"
            cell.Cover.image = #imageLiteral(resourceName: "biografias")
            return cell
        } else if indexPath.row == 4 {
            cell.Category.text = "Ciencia y Naturaleza"
            cell.Cover.image = #imageLiteral(resourceName: "ciencia y naturaleza")
            return cell
        } else if indexPath.row == 5 {
            cell.Category.text = "Literatura"
            cell.Cover.image = #imageLiteral(resourceName: "literatura")
            return cell
        } else if indexPath.row == 6 {
            cell.Category.text = "Historia"
            cell.Cover.image = #imageLiteral(resourceName: "Historia")
            return cell
        } else if indexPath.row == 7 {
            cell.Category.text = "Politica"
            cell.Cover.image = #imageLiteral(resourceName: "politica")
            return cell
        } else if indexPath.row == 8 {
            cell.Category.text = "Misterio y Suspenso"
            cell.Cover.image = #imageLiteral(resourceName: "suspenso")
            return cell
        } else if indexPath.row == 9 {
            cell.Category.text = "Tecnicos y Profesionales"
            cell.Cover.image = #imageLiteral(resourceName: "tecnicos")
            return cell
        } else {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedCategory = "Informatica"
            selectedCategoryFB = "Informatica"
        } else if indexPath.row == 1 {
            selectedCategory = "Novelas"
            selectedCategoryFB = "Novelas"
        } else if indexPath.row == 2 {
            selectedCategory = "Ciencia Ficcion"
            selectedCategoryFB = "CienciaFiccion"
        } else if indexPath.row == 3 {
            selectedCategory = "Biografias"
            selectedCategoryFB = "Biografias"
        } else if indexPath.row == 4 {
            selectedCategory = "Ciencia y Naturaleza"
            selectedCategoryFB = "CienciaYNaturaleza"
        } else if indexPath.row == 5 {
            selectedCategory = "Literatura"
            selectedCategoryFB = "Literatura"
        } else if indexPath.row == 6 {
            selectedCategory = "Historia"
            selectedCategoryFB = "Historia"
        } else if indexPath.row == 7 {
            selectedCategory = "Politica"
            selectedCategoryFB = "Politica"
        } else if indexPath.row == 8 {
            selectedCategory = "Misterio y Suspenso"
            selectedCategoryFB = "MisterioYSuspenso"
        } else if indexPath.row == 9 {
            selectedCategory = "Tecnicos y Profesionales"
            selectedCategoryFB = "TecnicosYProfesionales"
        }
        performSegue(withIdentifier: "booksCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksCategory" {
            if let bookscategory = segue.destination as? BooksCategoryViewController {
                bookscategory.SectionN = selectedCategory
                bookscategory.SectionNFB = selectedCategoryFB
            }
        }
    }
    
    func BackHandle () {
        
        dismiss(animated: true, completion: nil)
        
    }
}
