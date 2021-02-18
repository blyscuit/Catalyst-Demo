//
//  ListWidget.swift
//  ListWidget
//
//  Created by Bliss on 18/2/21.
//

import WidgetKit
import SwiftUI

struct ListWidgetEntryView : View {
    let entry: ListEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(entry.items, id: \.id) { entry in
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: nil, content: {
                    Text(entry.id).multilineTextAlignment(.leading)
                    Text(entry.title).multilineTextAlignment(.trailing)
                })
                .padding()
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

@main
struct ListWidget: Widget {
    let kind: String = "ListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ListTimeline()) { entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ListWidget_Previews: PreviewProvider {
    static var previews: some View {
        ListWidgetEntryView(entry: ListEntry(date: Date(), items: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
