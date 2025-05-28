
import WidgetKit
import SwiftUI

struct MockEntry: TimelineEntry {
    let date: Date
    let items: [MockItem]
}

struct MockItem: Identifiable {
    let id = UUID()
    let name: String
    let time: Date
}

struct MockProvider: TimelineProvider {
  func placeholder(in context: Context) -> MockEntry {
    makeEntry()
  }

  func getSnapshot(in context: Context,
                   completion: @escaping (MockEntry) -> Void) {
    completion(makeEntry())
  }

  func getTimeline(in context: Context,
                   completion: @escaping (Timeline<MockEntry>) -> Void) {
    let entry = makeEntry()
    let refresh = Calendar.current.date(byAdding: .minute, value: 1, to: entry.date)!
    completion(.init(entries: [entry], policy: .after(refresh)))
  }

  private func makeEntry() -> MockEntry {
    let now = Date()
    let items = [
      MockItem(name: "Аспирин",     time: now.addingTimeInterval( 3600)),
      MockItem(name: "Витамин C",   time: now.addingTimeInterval( 7200)),
      MockItem(name: "Антибиотик",  time: now.addingTimeInterval(10800)),
    ]
    return .init(date: now, items: items)
  }
}

struct MockWidgetView: View {
  let entry: MockEntry

  var body: some View {
    ZStack { Color.accentColor.opacity(0.12) }
      .overlay(
        VStack(alignment: .leading, spacing: 8) {
          Text("Ближайшие приёмы")
            .font(.headline)
            .padding(.bottom, 4)

          ForEach(entry.items.prefix(2)) { item in
            HStack {
              VStack(alignment: .leading) {
                Text(item.name)
                  .font(.subheadline)
                Text(item.time, style: .time)
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              Spacer()
              Link("✅", destination: URL(string: "tabletnica://dummy?taken=\(item.id)")!)
              Link("❌", destination: URL(string: "tabletnica://dummy?skipped=\(item.id)")!)
            }
          }
        }
        .padding(12)
      )
  }
}

@main
struct MockNextMedWidget: Widget {
  let kind = "MockNextMedWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind,
                        provider: MockProvider()) { entry in
      MockWidgetView(entry: entry)
    }
    .configurationDisplayName("Виджет с напоминаниями")
    .description("Показывает ближайшие приемы препаратов согласно курсам.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
