import Reachability

// MARK: 인터넷이 연결되었는지 확인하는 함수
func isInternetReachable() -> Bool {
    let reachability = try! Reachability()

    if reachability.connection != .unavailable {
        return true
    } else {
        return false
    }
}
