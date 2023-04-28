import UIKit

extension HomeScreenViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            view.backgroundColor = ThemeColorSet["mainColor"]
            NostelgiAlbumLabel.backgroundColor = ThemeColorSet["mainColor"]
            homeTitleView.backgroundColor = ThemeColorSet["mainColor"]
            collectionView.backgroundColor = ThemeColorSet["subColor_1"]
            topLabel.backgroundColor = ThemeColorSet["subColor_2"]
        } else {
            return
        }
    }
}

extension HomeScreenCollectionViewCell {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            self.backgroundColor = ThemeColorSet["subColor_1"]
            self.bottomLabel.backgroundColor = ThemeColorSet["subColor_2"]
            self.firstButton.backgroundColor = ThemeColorSet["subColor_3"]
            self.secondButton.backgroundColor = ThemeColorSet["subColor_3"]
        } else {
            return
        }
    }
}

extension HomeEditViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            self.createButton.backgroundColor = ThemeColorSet["subColor_3"]
            self.cancleButton.backgroundColor = ThemeColorSet["subColor_3"]
            self.selectButton.backgroundColor = ThemeColorSet["subColor_3"]
            self.coverImage.backgroundColor = .white
            self.albumName.backgroundColor = .white
            self.divideLine.backgroundColor = ThemeColorSet["subColor_2"]
            self.editView.backgroundColor = ThemeColorSet["subColor_1"]
        } else {
            return
        }
    }
}

extension AlbumScreenViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            self.view.backgroundColor = ThemeColorSet["mainColor"]
            self.navigationController?.navigationBar.backgroundColor = ThemeColorSet["mainColor"]
            self.navigationController?.toolbar.backgroundColor = ThemeColorSet["mainColor"]
            collectionView.backgroundColor = ThemeColorSet["subColor_1"]
            topLabel.backgroundColor = ThemeColorSet["subColor_2"]
            bottomLabel.backgroundColor = ThemeColorSet["subColor_2"]
        } else {
            return
        }
    }
}

extension AlbumScreenCollectionViewCell {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            self.backgroundColor = ThemeColorSet["subColor_1"]
            self.pictureImgButton?.backgroundColor = ThemeColorSet["subColor_3"]
        } else {
            return
        }
    }
}

extension AlbumEditViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            view.backgroundColor = ThemeColorSet["mainColor"]
            bodyView.backgroundColor = ThemeColorSet["subColor_1"]
            topLabel.backgroundColor = ThemeColorSet["subColor_2"]
            bottomLabel.backgroundColor = ThemeColorSet["subColor_2"]
            editPicture.backgroundColor = ThemeColorSet["subColor_3"]
            saveButton.backgroundColor = ThemeColorSet["subColor_4"]
        } else {
            return
        }
    }
}

extension AlbumPicViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            view.backgroundColor = ThemeColorSet["mainColor"]
            bodyView.backgroundColor = ThemeColorSet["subColor_1"]
            topLabel.backgroundColor = ThemeColorSet["subColor_2"]
            bottomLabel.backgroundColor = ThemeColorSet["subColor_2"]
            picImage.backgroundColor = ThemeColorSet["subColor_3"]
            settingBtn.tintColor = ThemeColorSet["mainColor"]
        } else {
            return
        }
    }
}

extension ImageViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            scrollView.backgroundColor = ThemeColorSet["subColor_1"]
            closeButton.tintColor = ThemeColorSet["mainColor"]
        } else {
            return
        }
    }
}

extension InfoTableViewController {
    func setThemeColor() {
        let HomeSettingInfo = realm.objects(HomeSetting.self).first!
        if let ThemeColorSet = getColorSet(color: HomeSettingInfo.themeColor) {
            view.backgroundColor = ThemeColorSet["subColor_1"]
            tableView.backgroundColor = ThemeColorSet["subColor_1"]
        } else {
            return
        }
    }
}

func getColorSet(color: String) -> [String: UIColor]? {
    let ThemeColorSet = ThemeColorSet()
    var colorSet: [String: UIColor]? = nil
    switch color {
    case "blue": colorSet = ThemeColorSet.blue
    case "brown": colorSet = ThemeColorSet.brown
    case "green": colorSet = ThemeColorSet.green
    default: print("error occur")
    }
    return colorSet
}
