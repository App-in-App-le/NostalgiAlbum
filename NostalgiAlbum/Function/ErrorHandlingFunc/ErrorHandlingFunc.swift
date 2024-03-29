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
        
    case let nsError as NSError where nsError.domain == NSCocoaErrorDomain:
        switch nsError.code {
        case NSFileWriteFileExistsError:
            titleText = "기존 파일 존재"
            messageText = "기존의 파일이 존재하고 있습니다."
            
        case NSFileWriteInapplicableStringEncodingError:
            titleText = "인코딩 문제"
            messageText = "인코딩이 맞지 않아 파일 작성이 불가합니다."
            
        case NSFileWriteInvalidFileNameError:
            titleText = "잘못된 이름"
            messageText = "파일 이름이 잘못되었습니다."
            
        case NSFileWriteNoPermissionError:
            titleText = "권한 부재"
            messageText = "파일을 작성할 권한이 없습니다."
            
        case NSFileWriteOutOfSpaceError:
            titleText = "용량 부족"
            messageText = "디바이스에 용량이 부족합니다."
            
        case NSFileWriteVolumeReadOnlyError:
            titleText = "읽기 전용"
            messageText = "현재 읽기만 가능한 상태입니다."
            
        case NSUbiquitousFileNotUploadedDueToQuotaError:
            titleText = "아이클라우드 업로드 실패"
            messageText = "아이클라우드 저장소의 용량이 부족합니다."
            
        case NSUbiquitousFileUbiquityServerNotAvailable:
            titleText = "아이클라우드 서버 연결 실패"
            messageText = "아이클라우드 서비스를 사용할 수 없습니다. 설정에서 앱의 아이클라우드 권한을 추가해주세요."
            
        case NSFileWriteUnknownError:
            titleText = "이미지 저장 실패"
            messageText = "이미지 저장이 실패하였습니다."
            
        default:
            titleText = "동작 실패 (2)"
            messageText = "동작이 실패하였습니다. 다시 시도해주세요."
        }
        
    case let nsError as NSError where nsError.code == NSFileWriteVolumeReadOnlyError:
        titleText = "읽기 전용"
        messageText = "현재 읽기만 가능한 상태입니다."
    
    case HomeScreenViewErrorMessage.reviewAlbumError:
        titleText = "앨범 수정 실패"
        messageText = "앨범 수정 중 사진 파일이 손상되었습니다."
        
    case HomeScreenViewErrorMessage.deleteAlbumError:
        titleText = "앨범 삭제 실패"
        messageText = "앨범 삭제를 실패하였습니다."
        
    case ErrorMessage.notNost:
        titleText = "잘못된 파일"
        messageText = "잘못된 파일 형식입니다.\n 앱을 업데이트 후 다시 nost파일을 생성해주세요."
        
    case let nsError as NSError where nsError.domain == "io.realm":
        titleText = "데이터 베이스 오류"
        messageText = "데이터 베이스에서 오류가 발생하였습니다."
        
    case let nsError as NSError where nsError.domain == NSURLErrorDomain:
        if nsError.code == NSURLErrorNotConnectedToInternet {
            titleText = "인터넷 연결"
            messageText = "인터넷 연결이 필요합니다."
        } else {
            titleText = "NSURLError"
            messageText = "NSURLError가 발생했습니다."
        }
    default:
        titleText = "동작 실패 (1)"
        messageText = "동작이 실패하였습니다. 다시 시도해주세요."
    }
    
    let errorAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
    errorAlert.setFont(font: nil, title: titleText, message: messageText)
    let okAction = UIAlertAction(title: "확인", style: .default) { action in
        errorAlert.dismiss(animated: false)
    }
    errorAlert.addAction(okAction)
    vc.present(errorAlert, animated: true)
}
