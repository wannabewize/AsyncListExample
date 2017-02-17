//
//  ViewController.swift
//  SyncAsync
//

import UIKit

class ViewController: UIViewController {
    
    let urlStr = "https://github.com/wannabewize/AsyncListExample/blob/step1/images/wwdc2017.png?raw=true"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func loadSync(_ sender: Any) {
        imageView.image = nil
        defer {
            indicator.stopAnimating()
        }
        indicator.startAnimating()
        
        
        let url = URL(string: urlStr)!
        let data = try! Data(contentsOf: url)
        let image = UIImage(data: data)
        self.imageView.image = image
    }
    
    @IBAction func loadAsync1(_ sender: Any) {
        imageView.image = nil
        indicator.startAnimating()

        self.performSelector(inBackground: #selector(loadImage), with: nil)
    }
    
    func loadImage() {
        defer {
            indicator.performSelector(onMainThread: #selector(UIActivityIndicatorView.stopAnimating), with: nil, waitUntilDone: false)
        }
        
        let url = URL(string: urlStr)!
        let data = try! Data(contentsOf: url)
        let image = UIImage(data: data)
        self.imageView.performSelector(onMainThread: #selector(setter : UIImageView.image), with: image, waitUntilDone: false)
//        self.imageView.image = image
    }
    
    @IBAction func loadAsync2(_ sender: Any) {
        imageView.image = nil
        
        indicator.startAnimating()
        
        let downloader = ImageDownloader()
        downloader.imageView = imageView
        downloader.urlStr = urlStr
        downloader.completionHandler = {
            image in
                self.indicator.performSelector(onMainThread: #selector(UIActivityIndicatorView.stopAnimating), with: nil, waitUntilDone: false)
                self.imageView.performSelector(onMainThread: #selector(setter : UIImageView.image), with: image, waitUntilDone: false)
        }
        downloader.start()
    }
    
    class ImageDownloader : Thread {
        var imageView : UIImageView!
        var urlStr : String!
        var completionHandler : ((UIImage?) -> ())!
        
        override func main() {
            let url = URL(string: urlStr)!
            let imageData = try! Data(contentsOf: url)
            let image = UIImage(data: imageData)
            
//            imageView.image = image
            completionHandler(image)
        }
    }
    
    @IBAction func loadAsync3(_ sender: Any) {
        imageView.image = nil
        indicator.startAnimating()
        
        Thread.detachNewThread {
            let url = URL(string: self.urlStr)!
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            
            self.imageView.performSelector(onMainThread: #selector(setter:UIImageView.image), with: image, waitUntilDone: false)
            self.indicator.performSelector(onMainThread: #selector(UIActivityIndicatorView.stopAnimating), with: nil, waitUntilDone: false)
        }
    }
    
    @IBAction func loadAsync4(_ sender: Any) {
        imageView.image = nil
        indicator.startAnimating()
        
        let session = URLSession.shared
        let url = URL(string: self.urlStr)!
        let task = session.dataTask(with: url) { (data, response, error) in
            defer {
                OperationQueue.main.addOperation {
                    self.indicator.stopAnimating()
                }
            }
            guard error == nil else {
                print("Error : \(error?.localizedDescription)")
                return
            }
            print("is Main Thread : \(Thread.isMainThread)")
            let image = UIImage(data: data!)
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
        task.resume()
    }
    
    @IBAction func loadAsync5(_ sender: Any) {
        imageView.image = nil
        
        UIView.animate(withDuration: 1.0, animations: { 
            print("animated : isMain \(Thread.isMainThread)")
        }) { (finished : Bool) in
            print("completion : isMain \(Thread.isMainThread)")
        }

        
        let queue = OperationQueue()
        let operation = ImageOperation()
        operation.imageView = self.imageView
        operation.urlStr = urlStr
        queue.addOperation(operation)
    }
    
    class ImageOperation : Operation {
        var imageView : UIImageView!
        var urlStr : String!
        var completionHandler : ((UIImage?) -> ())!
        
        override func main() {
            let url = URL(string: urlStr)!
            let imageData = try! Data(contentsOf: url)
            let image = UIImage(data: imageData)
            
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

