# 비동기 목록 예제

## Step1

동기식 방식으로 목록 출력하기

    let urlStr = "http://hostaddress.com/image.png"
    let url = URL(string: urlStr)!
    let imageData = try! Data(contentsOf: url)
    let image = UIImage(data: imageData)
    cell.imageView?.image = image
