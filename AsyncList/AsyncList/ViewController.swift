//
//  ViewController.swift
//  AsyncList
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // https://github.com/wannabewize/AsyncListExample/blob/master/images/l.png?raw=true
    let baseURL = "https://github.com/wannabewize/AsyncListExample/blob/master/images/"
    let data = ["a","b","c","d","e","f","g","h","i","j","k","l","m","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9"]
    
    var queue : OperationQueue!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        let character = data[indexPath.row]
        cell.textLabel?.text = character
        
        // 이미지 경로
        let urlStr = "\(baseURL)\(character).png?raw=true"
        let url = URL(string: urlStr)!
        
        queue.addOperation {
            let imageData = try! Data(contentsOf: url)
            
            let image = UIImage(data: imageData)
            
            OperationQueue.main.addOperation {
                cell.imageView?.image = image
            }
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
    }
    
}//https://github.com/wannabewize/AsyncListExample/blob/step1/images/0.png?raw=true
