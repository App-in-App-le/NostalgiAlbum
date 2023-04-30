import Foundation

struct FontSet {
    let font: [String: String] = ["수박 화체": "EF_watermelonSalad", "지마켓 산스체": "GmarketSansMedium", "평창평화체": "PyeongChangPeace-Light"]
}

func GetKorFontName(engFontName: String) -> String {
    switch engFontName {
    case "GmarketSansMedium":
        return "지마켓 산스체"
    case "EF_watermelonSalad":
        return "수박 화체"
    case "PyeongChangPeace-Light":
        return "평창평화체"
    default:
        return ""
    }
}
