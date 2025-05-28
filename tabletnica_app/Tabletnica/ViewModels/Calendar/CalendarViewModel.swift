//
//  CalendarViewModel.swift
//  Tabletnica
//

import Foundation
import Combine

struct CalendarEntry: Identifiable {
    let id   : Date
    let name : String
    let taken: Bool?
}

@MainActor
final class CalendarViewModel: ObservableObject {

    @Published var selectedDate: Date = .now
    @Published private(set) var allEntries: [CalendarEntry] = []

    var entriesForSelected: [CalendarEntry] {
        let cal = Calendar.current
        return allEntries
            .filter { cal.isDate($0.id, inSameDayAs: selectedDate) }
            .sorted { $0.id < $1.id }
    }

    private let medService   : MedicationServiceProtocol
    private let courseService: CourseServiceProtocol

    init(
        medService   : MedicationServiceProtocol = MockMedicationService.shared,
        courseService: CourseServiceProtocol    = MockCourseService.shared
    ) {
        self.medService    = medService
        self.courseService = courseService
    }

    func load() {
        let cal        = Calendar.current
        let horizonEnd = cal.date(byAdding: .month, value: 6, to: .now)!

        medService.fetchMedications { [weak self] medRes in
            guard
                let self,
                case .success(let meds) = medRes
            else { return }

            var tmp: [CalendarEntry] = []

            for m in meds {
                self.courseService.fetchCourses(for: m.id) { res in
                    guard case .success(let courses) = res else { return }

                    for c in courses {
                        let dates = Self.schedule(for: c,
                                                  until: horizonEnd,
                                                  cal: cal)

                        for d in dates {
                            for t in c.times {
                                let dt = cal.date(
                                    bySettingHour  : cal.component(.hour  , from: t),
                                    minute         : cal.component(.minute, from: t),
                                    second         : 0,
                                    of             : d
                                )!

                                let taken: Bool?
                                if let lt = m.lastTakenDate,
                                   cal.isDate(lt, inSameDayAs: dt)      { taken = true  }
                                else if let ls = m.lastSkippedDate,
                                        cal.isDate(ls, inSameDayAs: dt) { taken = false }
                                else                                   { taken = nil   }

                                tmp.append(.init(id: dt,
                                                 name: m.name,
                                                 taken: taken))
                            }
                        }
                    }

                    Task { @MainActor in self.allEntries = tmp }
                }
            }
        }
    }

    private static func schedule(
        for c: Course,
        until horizon: Date,
        cal: Calendar
    ) -> [Date] {
        var out: [Date] = []
        var cur = cal.startOfDay(for: c.startDate)
        let end = cal.startOfDay(for: c.endDate ?? horizon)

        switch c.recurrenceType {
        case .daily:
            while cur <= end {
                out.append(cur)
                cur = cal.date(byAdding: .day, value: 1, to: cur)!
            }

        case .everyNDays:
            let step = max(c.everyNDays ?? 1, 1)
            while cur <= end {
                out.append(cur)
                cur = cal.date(byAdding: .day, value: step, to: cur)!
            }

        case .weekly:
            let wanted = Set(c.weekDays ?? [])

            while cur <= end {
                if let wd = Weekday(rawValue: cal.component(.weekday, from: cur)),
                   wanted.contains(wd) {
                    out.append(cur)
                }
                cur = cal.date(byAdding: .day, value: 1, to: cur)!
            }

        case .cycle:
            let work = max(c.cycleWorkDays ?? 1, 1)
            let rest = max(c.cycleRestDays ?? 0, 0)
            while cur <= end {
                for _ in 0..<work where cur <= end {
                    out.append(cur)
                    cur = cal.date(byAdding: .day, value: 1, to: cur)!
                }
                cur = cal.date(byAdding: .day, value: rest, to: cur)!
            }

        case .asNeeded: break
        }
        return out
    }
}
