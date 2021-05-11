//
//  ViewController.swift
//  WikiSearch
//
//  Created by Mac19 on 10/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var buscarSearchBar: UITextField!
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string:"https://upload.wikimedia.org/wikipedia/commons/d/de/Wikipedia-logo_%28inverse%29.png")!))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buscarPalabra(_ sender: UIButton) {
        guard let palabra = buscarSearchBar.text else{
            return
        }
        buscarWiki(palabras: palabra)
    }
    func buscarWiki(palabras:String){
        if let Url = URL(string:"https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))"){
        let peticion = URLRequest(url: Url)
            
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, errr) in
                if (errr != nil){
                    print(errr?.localizedDescription)
                }else{
                    do {
                        let json =  try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        let querySub = json["query"] as! [String:Any]
                        let querySubPages = querySub["pages"] as! [String:Any]
                        
                        let pageId = querySubPages.keys
                        
                        let llave = pageId.first!
                        
                        let llaveint = Int(llave)!
                        
                        if llaveint < 0 {
                            DispatchQueue.main.async {
                                self.webView.loadHTMLString("<h1>No realizo una busqueda correcta, parametros incorrectos</h1    >", baseURL: nil)
                            }
                        }else{
                            let result = querySubPages[llave] as! [String: Any]
                            
                            if     let extracto = result["extract"] as? String {
                                DispatchQueue.main.async {
                                    self.webView.loadHTMLString(extracto, baseURL: nil)
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self.webView.loadHTMLString("<h1>Sin resultados</h1    >", baseURL: nil)
                                }
                            }
                        }
                        
                        	
                        

                        
                        
                    } catch  {
                        print(errr?.localizedDescription)
                    }
                }
                
            }
            tarea.resume()
    }
        
    }


}

