
import Foundation

enum SharedStorage {
    private static let suite = UserDefaults(suiteName: "group.sonya.Tabletnica")!

    static func saveMeds(_ meds: [Medication]) {
        guard let data = try? JSONEncoder().encode(meds) else { return }
        suite.set(data, forKey: "medications")
    }

    static func loadMeds() -> [Medication] {
        guard
            let data = suite.data(forKey: "medications"),
            let meds = try? JSONDecoder().decode([Medication].self, from: data)
        else { return [] }
        return meds
    }


    static func saveCourses(_ courses: [Course], for medId: Int) {
        guard let data = try? JSONEncoder().encode(courses) else { return }
        suite.set(data, forKey: "courses-\(medId)")
    }

    static func loadCourses(for medId: Int) -> [Course] {
        guard
            let data = suite.data(forKey: "courses-\(medId)"),
            let arr  = try? JSONDecoder().decode([Course].self, from: data)
        else { return [] }
        return arr
    }
}
