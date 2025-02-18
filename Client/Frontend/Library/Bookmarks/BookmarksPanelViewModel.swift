// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Storage
import Shared

class BookmarksPanelViewModel {

    enum BookmarksSection: Int, CaseIterable {
        case bookmarks
    }

    var isRootNode: Bool {
        return bookmarkFolderGUID == BookmarkRoots.MobileFolderGUID
    }

    let profile: Profile
    let bookmarkFolderGUID: GUID
    var bookmarkFolder: FxBookmarkNode?
    var bookmarkNodes = [FxBookmarkNode]()
    private var flashLastRowOnNextReload = false

    /// By default our root folder is the mobile folder. Desktop folders are shown in the local desktop folders.
    init(profile: Profile,
         bookmarkFolderGUID: GUID = BookmarkRoots.MobileFolderGUID) {
        self.profile = profile
        self.bookmarkFolderGUID = bookmarkFolderGUID
    }

    var shouldFlashRow: Bool {
        guard flashLastRowOnNextReload else { return false }
        flashLastRowOnNextReload = false

        return true
    }

    func reloadData(completion: @escaping () -> Void) {
        // Can be called while app backgrounded and the db closed, don't try to reload the data source in this case
        if profile.isShutdown {
            completion()
            return
        }

        if bookmarkFolderGUID == BookmarkRoots.MobileFolderGUID {
            setupMobileFolderData(completion: completion)

        } else if bookmarkFolderGUID == LocalDesktopFolder.localDesktopFolderGuid {
            setupLocalDesktopFolderData(completion: completion)

        } else {
            setupSubfolderData(completion: completion)
        }
    }

    func didAddBookmarkNode() {
        flashLastRowOnNextReload = true
    }

    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let bookmarkNode = bookmarkNodes[safe: sourceIndexPath.row] else {
            return
        }

        let newIndex = getNewIndex(from: destinationIndexPath.row)
        _ = profile.places.updateBookmarkNode(guid: bookmarkNode.guid, position: UInt32(newIndex))

        bookmarkNodes.remove(at: sourceIndexPath.row)
        bookmarkNodes.insert(bookmarkNode, at: destinationIndexPath.row)
    }

    // MARK: - Private

    /// Since we have a Local Desktop folder that isn't referenced in A-S under the mobile folder, we need to account for this when saving bookmark index in A-S.
    /// Index is calculated by inverting it inside the mobile folder. We also need to account for the local desktop folder spot it takes.
    func getNewIndex(from index: Int) -> Int {
        if bookmarkFolderGUID == BookmarkRoots.MobileFolderGUID {
            let mobileFolderIndex = bookmarkNodes.count - index - LocalDesktopFolder.numberOfRowsTaken
            if mobileFolderIndex < 0 {
                return 0
            } else if mobileFolderIndex > bookmarkNodes.count {
                return bookmarkNodes.count - LocalDesktopFolder.numberOfRowsTaken
            }

            return mobileFolderIndex
        } else {
            return index
        }
    }

    private func setupMobileFolderData(completion: @escaping () -> Void) {
        profile.places
            .getBookmarksTree(rootGUID: BookmarkRoots.MobileFolderGUID, recursive: false)
            .uponQueue(.main) { result in
                guard let mobileFolder = result.successValue as? BookmarkFolderData else {
                    self.setErrorCase()
                    completion()
                    return
                }

                self.bookmarkFolder = mobileFolder
                // Reversed since we want the newest mobile bookmarks at the top
                self.bookmarkNodes = mobileFolder.fxChildren?.reversed() ?? []

                let desktopFolder = LocalDesktopFolder()
                self.bookmarkNodes.insert(desktopFolder, at: 0)

                completion()
            }
    }

    /// Local desktop folder data is a folder that only exists locally in the application
    /// It contains the three desktop folder of "unfiled", "menu" and "toolbar"
    private func setupLocalDesktopFolderData(completion: () -> Void) {
        let unfiled = LocalDesktopFolder(forcedGuid: BookmarkRoots.UnfiledFolderGUID)
        let toolbar = LocalDesktopFolder(forcedGuid: BookmarkRoots.ToolbarFolderGUID)
        let menu = LocalDesktopFolder(forcedGuid: BookmarkRoots.MenuFolderGUID)

        self.bookmarkFolder = nil
        self.bookmarkNodes = [unfiled, toolbar, menu]
        completion()
    }

    /// Subfolder data case happens when we select a folder created by a user
    private func setupSubfolderData(completion: @escaping () -> Void) {
        profile.places.getBookmarksTree(rootGUID: bookmarkFolderGUID,
                                        recursive: false).uponQueue(.main) { result in
            guard let folder = result.successValue as? BookmarkFolderData else {
                self.setErrorCase()
                completion()
                return
            }

            self.bookmarkFolder = folder
            self.bookmarkNodes = folder.fxChildren ?? []

            completion()
        }
    }

    /// Error case at the moment is setting data to nil and showing nothing
    private func setErrorCase() {
        self.bookmarkFolder = nil
        self.bookmarkNodes = []
    }
}
