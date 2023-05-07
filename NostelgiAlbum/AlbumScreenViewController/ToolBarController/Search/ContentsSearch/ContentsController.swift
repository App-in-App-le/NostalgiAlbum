import UIKit
import RealmSwift

class ContentsController {
    // MARK: - Properties
    let realm = try! Realm()
    var coverIndex: Int = -1
    
    // Search struct
    struct Search: Hashable {
        // MARK: - Search Struct Properties
        let name: String
        let contents: String
        let page: Int
        let identifier = UUID()
        
        // MARK: - Search Struct Methods
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: Search, rhs: Search) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        // SearchBar의 text를 전달받아 name및 contents에서 해당 text를 포함하는지 확인하고 return
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty { return true }
            let lowcasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowcasedFilter) || contents.lowercased().contains(lowcasedFilter)
        }
    }
    // searched true -> return searched list | searched false -> return all searches list
    func filteredSearch(with filter: String?=nil, limit: Int?=nil) -> [Search] {
        let filtered = searches.filter { $0.contains(filter) }
        if filter == nil || filter == "" {
            return []
        }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
        
    }
    // searches closure -> return search name & contents list
    private lazy var searches: [Search] = {
        return generateSearch()
    }()
}
// ContentsController extension -> load album data & generate search struct
extension ContentsController {
    private func generateSearch() -> [Search] {
        let datas = realm.objects(album.self).filter("index = \(coverIndex)")
        var searches = [Search]()
        for data in datas {
            let name = data.ImageName
            let contents = data.ImageText
            let page = (data.perAlbumIndex - 1)/2
            searches.append(Search(name: name, contents: contents, page: page))
        }
        return searches
    }
}
