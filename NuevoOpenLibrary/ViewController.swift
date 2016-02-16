//
//  ViewController.swift
//  NuevoOpenLibrary
//
//  Created by Javier Oñate Mendía on 2/16/16.
//  Copyright © 2016 Dédalo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK : outlets
    
    @IBOutlet weak var isbn: UITextField!
    
    @IBOutlet weak var resultados: UITextView!
    
    @IBOutlet weak var error: UILabel!
    
    
    // MARK: defaults
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: actions
    
    @IBAction func borrar() {
        self.isbn.text = ""
        self.resultados.text = ""
        self.error.text = ""
    }
    
    @IBAction func buscar() {
        buscarSincrono()
    }

    // MARK: jom
    
    func buscarSincrono()
    {
        let isbnTexto = self.isbn.text! as String
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbnTexto)"
        let url = NSURL(string: urls)
        if let datos:NSData? = NSData(contentsOfURL: url!){
            
            if datos == nil {
                self.error.text = "No se encontro la direccion."
            }else{
                let texto =  NSString(data:datos!, encoding:NSUTF8StringEncoding)
                if texto=="{}"{
                    self.error.text = "No se encontro el ISBN."
                    self.resultados.text = ""
                }else{
                    self.error.text = ""
                    self.resultados.text = texto as! String
                }
            }
        }else{
            self.error.text = "No se encontro la direccion."
        }
    }
    
    // MARK: UITextFieldDelegate
    
    @objc func textFieldShouldReturn(textField: UITextField) -> Bool {
        //print("dentro de textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidEndEditing(textField: UITextField) {
        //print("dentro de textFieldDidEndEditing")
        buscarSincrono()
    }
}

