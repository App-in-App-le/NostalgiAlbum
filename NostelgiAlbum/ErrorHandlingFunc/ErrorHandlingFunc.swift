import Foundation
import Zip
import RealmSwift

func NSErrorHandling_Alert(error: Error, vc: UIViewController) {
    var titleText = ""
    var messageText = ""
    
    switch error {
    case ZipError.zipFail:
        titleText = "압축 실패"
        messageText = "압축에 실패했습니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteFileExistsError:
        titleText = "기존 파일 존재"
        messageText = "기존의 파일이 존재하고 있습니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteInapplicableStringEncodingError:
        titleText = "인코딩 문제"
        messageText = "인코딩이 맞지 않아 파일 작성이 불가합니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteInvalidFileNameError:
        titleText = "잘못된 이름"
        messageText = "파일 이름이 잘못되었습니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteNoPermissionError:
        titleText = "권한 부재"
        messageText = "파일을 작성할 권한이 없습니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteOutOfSpaceError:
        titleText = "용량 부족"
        messageText = "디바이스에 용량이 부족합니다."
        
    case let nsError as NSError where nsError.code == NSFileWriteVolumeReadOnlyError:
        titleText = "읽기 전용"
        messageText = "현재 읽기만 가능한 상태입니다."
    
    case ErrorMessage.notNost:
        titleText = "잘못된 파일"
        messageText = "잘못된 파일 형식입니다."
    
    
    // iCloud Error 추가 필요
        
    default:
        titleText = "파일 생성 실패"
        messageText = "파일 생성에 실패했습니다. 다시 시도해주세요."
    }
    
    let errorAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
    errorAlert.setFont(font: nil, title: titleText, message: messageText)
    let okAction = UIAlertAction(title: "확인", style: .default) { action in
        errorAlert.dismiss(animated: false)
    }
    errorAlert.addAction(okAction)
    vc.present(errorAlert, animated: true)
}
