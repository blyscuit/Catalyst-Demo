//
//  HomeTouchBar.swift
//  Catalyst-Demo
//
//  Created by Bliss on 24/2/21.
//

import UIKit

#if targetEnvironment(macCatalyst)
extension NSTouchBarItem.Identifier {

    static func itemIdentifier(id: String) -> NSTouchBarItem.Identifier {  NSTouchBarItem.Identifier("\(itemPretext)\(id)") }
    static let itemPretext = "com.example.apple-samplecode.Recipes.deleteRecipe."
}

extension HomeViewController: NSTouchBarDelegate {

    @objc private func selectTouchBarItem(sender: NSTouchBarItem?) {
        guard let touchBarItem = sender else {
            return
        }
        let id = touchBarItem.identifier.rawValue.replacingOccurrences(of: NSTouchBarItem.Identifier.itemPretext, with: "")
        output?.didSelect(id: id)
    }

    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self

        touchBar.defaultItemIdentifiers = self.viewModels.map { NSTouchBarItem.Identifier.itemIdentifier(id: $0.country) }

        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let touchBarItem: NSTouchBarItem?

        let id = identifier.rawValue.replacingOccurrences(of: NSTouchBarItem.Identifier.itemPretext, with: "")
        touchBarItem = NSButtonTouchBarItem(identifier: identifier,
                                            title: id,
                                            target: self,
                                            action: #selector(selectTouchBarItem(sender:)))


        return touchBarItem
    }

}
#endif
