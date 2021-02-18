//
//  ListEntry.swift
//  ListWidgetExtension
//
//  Created by Bliss on 18/2/21.
//

import SwiftUI
import WidgetKit
import Alamofire

struct ListItem {

    let id: String
    let title: String
}

struct ListEntry: TimelineEntry {

    public let date: Date
    public let items: [ListItem]
}

struct ListLoader {

    static func fetch(completion: @escaping (Result<[ListItem], Error>) -> Void) {
        NetworkServiceFactory.shared.setUp(baseURL: "https://api.covid19api.com")
        let dataService = NetworkServiceFactory.shared.createDataService()
        _ = dataService.fetchData {
            switch $0 {
            case .success(let model):
                completion(.success((model.countries).map { ListItem(id: $0.country, title: "\($0.totalConfirmed)") }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct ListTimeline: TimelineProvider {

    typealias Entry = ListEntry

    func placeholder(in context: Context) -> ListEntry {
        let entry = ListEntry(date: Date(), items: [ListItem(id: "", title: ""), ListItem(id: "", title: ""), ListItem(id: "", title: "")])
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (ListEntry) -> Void) {
        let currentDate = Date()

        let itemNumber = Int(context.displaySize.height / 50.0)

        ListLoader.fetch { result in
            let items: [ListItem]
            switch result {
            case .success(let list):
                items = Array(list.prefix(itemNumber))
            case .failure(let error):
                items = [ListItem(id: error.localizedDescription, title: error.localizedDescription)]
            }
            let entry = ListEntry(date: currentDate, items: items)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ListEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        let itemNumber = Int(context.displaySize.height / 50.0)

        ListLoader.fetch { result in
            let items: [ListItem]
            switch result {
            case .success(let list):
                items = Array(list.prefix(itemNumber))
            case .failure(let error):
                items = [ListItem(id: error.localizedDescription, title: error.localizedDescription)]
            }
            let entry = ListEntry(date: currentDate, items: items)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
