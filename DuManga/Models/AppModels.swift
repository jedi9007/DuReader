//
// Created on 10/9/20.
//

import Foundation

enum PageControl: String, CaseIterable, Identifiable {
    case next
    case previous
    case navigation

    var id: String { self.rawValue }
}

struct SettingsKey {
    static let lanraragiUrl = "settings.lanraragi.url"
    static let lanraragiApiKey = "settings.lanraragi.apiKey"
    static let tapLeftKey = "settings.read.tap.left"
    static let tapMiddleKey = "settings.read.tap.middle"
    static let tapRightKey = "settings.read.tap.right"
    static let swipeLeftKey = "settings.read.swipe.left"
    static let swipeRightKey = "settings.read.swipe.right"
    static let splitPage = "settings.read.split.page"
    static let splitPagePriorityLeft = "settings.read.split.page.priority.left"
    static let archiveListRandom = "settings.archive.list.random"
    static let useListView = "settings.view.use.list"
}

struct ErrorCode: Equatable {

    static func == (lhs: ErrorCode, rhs: ErrorCode) -> Bool {
        lhs.name == rhs.name
                && lhs.code == rhs.code
    }

    let name: String
    let code: Int

    private init(name: String, code: Int) {
        self.name = name
        self.code = code
    }

    static let lanraragiServerError = ErrorCode(name: "error.host", code: 1000)

    static let archiveFetchError = ErrorCode(name: "error.list", code: 2000)
    static let archiveExtractError = ErrorCode(name: "error.extract", code: 2002)
    static let archiveFetchPageError = ErrorCode(name: "error.load.page", code: 2003)
    static let archiveUpdateMetadataError = ErrorCode(name: "error.update.metadata", code: 2004)

    static let categoryFetchError = ErrorCode(name: "error.category", code: 3000)
    static let categoryUpdateError = ErrorCode(name: "error.category.update", code: 3001)
}
