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
    
    @IBOutlet weak var error: UILabel!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var autores: UILabel!
    
    // MARK: defaults
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.delegate = self
        
        self.isbn.clearButtonMode = .Always
        self.error.text = ""
        self.titulo.text = ""
        self.autores.text = ""
    }

    // MARK: actions
    
    @IBAction func borrar() {
        self.isbn.text = ""
        self.error.text = ""
        self.titulo.text = ""
        self.autores.text = ""
        self.portada.image = nil
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
                self.error.text = "No se encontro la dirección."
            }else{
                let texto =  NSString(data:datos!, encoding:NSUTF8StringEncoding)
                if texto=="{}"{
                    self.error.text = "No se encontro el ISBN."
                    //self.resultados.text = ""
                }else{
                    do{
                        // traduce el json en strJson
                        let strJson = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                        
                        // pone en variable itemsLibro los atributos del json de acuerdo al isbn
                        let libro = strJson as! NSDictionary
                        let nombreIsbn = "ISBN:\(self.isbn.text!)"
                        let itemsLibro = libro[nombreIsbn] as! NSDictionary
                        
                        // pone el valor del titulo
                        let titulo = itemsLibro["title"] as! NSString as String
                        self.titulo.text = titulo
                        
                        // pone el valor de los diferentes autores en la variable strAutores
                        var strAutores: String = ""
                        let autores = itemsLibro["authors"] as! NSArray
                        for autor in autores{
                            let datosAutor = autor as! NSDictionary
                            let nombreAutor = datosAutor["name"] as! NSString as String
                            if (strAutores != ""){
                                strAutores += "; "
                            }
                            strAutores += nombreAutor
                        }
                        self.autores.text = strAutores
                        
                        // busca si existe la imagen
                        
                        if itemsLibro["cover"] != nil{
                            let portadas = itemsLibro["cover"] as! NSDictionary
                            var urlPortadaString: String = ""
                            if portadas["medium"] != nil{
                                urlPortadaString = portadas["medium"] as! NSString as String
                            }else if portadas["small"] != nil{
                                urlPortadaString = portadas["small"] as! NSString as String
                            } else if portadas["large"] != nil{
                                urlPortadaString = portadas["large"] as! NSString as String
                            }
                            let urlPortada  = NSURL(string: urlPortadaString), data = NSData(contentsOfURL: urlPortada!)
                            let imagePortada = UIImage(data: data!)
                            self.portada.image = imagePortada!
                        }else{
                            print("NO existe portada")
                            let imagen = UIImage(named: "default.jpg")!
                            self.portada.image = imagen
                        }
                        
                        
                        print("\(nombreIsbn)")
                        print("\(titulo)")
                    }
                    catch{
                        
                    }
                    self.error.text = ""
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

