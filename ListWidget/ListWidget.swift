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
        VStack(alignment: .leading, spacing: nil) {
            ForEach(entry.items, id: \.id) { entry in
                Link(destination: entry.widgetURL) {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4, content: {
                        Text(entry.id).multilineTextAlignment(.leading)
                        Spacer()
                        Text(entry.title).multilineTextAlignment(.trailing)
                    })
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity)
                    .padding()
                }
                Divider()
            }
        }
    }
}

@main
struct ListWidget: Widget {
    let kind: String = "List"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ListTimeline()) { entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("List")
        .description("List of items and detail.")
    }
}

struct ListWidget_Previews: PreviewProvider {
    static var previews: some View {
        ListWidgetEntryView(entry: ListEntry(date: Date(), items: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
