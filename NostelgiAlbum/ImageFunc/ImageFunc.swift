import UIKit

func saveImageToDocumentDirectory(imageName: String, image: UIImage, AlbumCoverName: String) throws {
    // 1. 이미지를 저장할 경로를 설정해줘야함 - 도큐먼트 폴더,File 관련된건 Filemanager가 관리함(싱글톤 패턴)
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    let imageURL = documentDirectory.appendingPathComponent(AlbumCoverName).appendingPathComponent(imageName)
    // 2. 이미지 파일 이름 & 최종 경로 설정
    NSLog(imageURL.path())
    // 돌아가는 방향 잡는 부분
    let changedImage = fixOrientation(image: image)

    // 3. 이미지 압축(image.pngData())
    // 압축할거면 jpegData로~(0~1 사이 값)
    // 2023/03/08 pngData -> jpegData
    guard let data = changedImage.jpegData(compressionQuality: 1) else {
        print("압축이 실패했습니다. \(NSError(domain: "NSCocoaErrorDomain", code: NSFileWriteUnknownError))")
        throw NSError(domain: "NSCocoaErrorDomain", code: NSFileWriteUnknownError)
    }

    // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
    // 4-1. 이미지 경로 여부 확인
    if FileManager.default.fileExists(atPath: imageURL.path) {
        // 4-2. 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let error {
            print("Error occur :: \(error)")
            throw error
        }
    }

    // 5. 이미지를 도큐먼트에 저장
    do {
        try data.write(to: imageURL)
    } catch let error as NSError {
        print("Error occur :: \(error)")
        throw error
    }
}

func loadImageFromDocumentDirectory(imageName: String, albumTitle: String) -> UIImage? {
    // 1. 도큐먼트 폴더 경로가져오기
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

    if let directoryPath = path.first {
        // 2. 이미지 URL 찾기
        let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(albumTitle).appendingPathComponent(imageName)
        // 3. UIImage로 불러오기
        let loadImage = UIImage(contentsOfFile: imageURL.path)
        if let loadImage = loadImage {
            return fixOrientation(image: loadImage)
        } else {
            return nil
        }
    }

    return nil
}

func deleteImageFromDocumentDirectory(imageName: String) throws {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}

    let imageURL = documentDirectory.appendingPathComponent(imageName)

    if FileManager.default.fileExists(atPath: imageURL.path) {
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let error {
            print("ERROR OCCUR :: \(error).")
            throw error
        }
    }
}

func fixOrientation(image: UIImage) -> UIImage{
    if(image.imageOrientation == .up){
        return image
    }
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    image.draw(in: rect)
    let normailizedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    return normailizedImage
}

extension UIImage {
    func resize(newWidth: CGFloat, newHeight: CGFloat, byScale: Bool) -> UIImage {
        if byScale == true {
            let nnewWidth = newWidth - 50
            let nnewHeight = newHeight - 50
            if self.size.width >= self.size.height {
                let scale = nnewWidth / self.size.width
                let nHeight = self.size.height * scale
                let size = CGSize(width: nnewWidth, height: nHeight)
                let render = UIGraphicsImageRenderer(size: size)
                let renderImage = render.image { context in self.draw(in: CGRect(origin: .zero, size: size))}
                return renderImage
            } else {
                let scale = nnewHeight / self.size.height
                let nWidth = self.size.width * scale
                let size = CGSize(width: nWidth, height: nnewHeight)
                let render = UIGraphicsImageRenderer(size: size)
                let renderImage = render.image { context in self.draw(in: CGRect(origin: .zero, size: size))}
                return renderImage
            }
        }
        else {
            let size = CGSize(width: newWidth, height: newHeight)
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image { context in self.draw(in: CGRect(origin: .zero, size: size))}
            return renderImage
        }
    }
}

func deleteTmpFiles() {
    let tmpDir = NSTemporaryDirectory()
    var fileList : Array<String>! = nil
    
    do {
        fileList = try FileManager.default.contentsOfDirectory(atPath: tmpDir)
    } catch {
        print("Error read tmp file")
    }
    do {
        for file in fileList {
            let resultDir = tmpDir+file
            try FileManager.default.removeItem(atPath: resultDir)
        }
    } catch {
        print("Error remove tmp file")
    }
}
