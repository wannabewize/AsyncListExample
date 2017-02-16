//
//  ViewController.swift
//  AsyncList
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // https://github.com/wannabewize/AsyncListExample/blob/master/images/l.png?raw=true
    let baseURL = "https://github.com/wannabewize/AsyncListExample/blob/master/images/"
    let data = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "o", "p","q","r","s","t","u","v","w","x","y","z", "0","1","2","3","4","5","6","7","8","9"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        let character = data[indexPath.row]
        cell.textLabel?.text = character
        
        // 이미지 경로
        let urlStr = "\(baseURL)\(character).png?raw=true"
        if let url = URL(string: urlStr) {
//            Thread.detachNewThread {
//                if let imageData = try? Data(contentsOf: url),
//                    let image = UIImage(data: imageData) {
//                    cell.imageView!.image = image
//                }
//            }
//            let downloader = ImageDownloader()
//            downloader.imageView = cell.imageView!
//            downloader.url = url
//            downloader.start()
            
            queue.addOperation {
                if let imageData = try? Data(contentsOf: url),
                    let image = UIImage(data: imageData) {
                    OperationQueue.main.addOperation {
                        cell.imageView!.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    var queue : OperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
    }

}

class ImageDownloader : Thread {
    var imageView : UIImageView!
    var url : URL!
    override func main() {
        if let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) {
            imageView.image = image
        }
    }
}

