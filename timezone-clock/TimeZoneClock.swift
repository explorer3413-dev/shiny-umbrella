import Foundation

/// Represents a time zone with its display information
struct TimeZoneInfo {
    let identifier: String
    let displayName: String
    let abbreviation: String
    
    var timeZone: TimeZone {
        return TimeZone(identifier: identifier) ?? TimeZone.current
    }
}

/// Manages multiple time zones and displays current time in each
class TimeZoneClock {
    private var timeZones: [TimeZoneInfo] = []
    private var timer: Timer?
    
    /// Default time zones to display
    private let defaultTimeZones = [
        TimeZoneInfo(identifier: "America/New_York", displayName: "New York (EST)", abbreviation: "EST"),
        TimeZoneInfo(identifier: "Europe/London", displayName: "London (GMT)", abbreviation: "GMT"),
        TimeZoneInfo(identifier: "Europe/Paris", displayName: "Paris (CET)", abbreviation: "CET"),
        TimeZoneInfo(identifier: "Asia/Tokyo", displayName: "Tokyo (JST)", abbreviation: "JST"),
        TimeZoneInfo(identifier: "Australia/Sydney", displayName: "Sydney (AEDT)", abbreviation: "AEDT"),
        TimeZoneInfo(identifier: "Asia/Dubai", displayName: "Dubai (GST)", abbreviation: "GST")
    ]
    
    init(timeZones: [TimeZoneInfo]? = nil) {
        self.timeZones = timeZones ?? defaultTimeZones
    }
    
    /// Add a new time zone to display
    func addTimeZone(_ timeZoneInfo: TimeZoneInfo) {
        timeZones.append(timeZoneInfo)
    }
    
    /// Remove a time zone from display
    func removeTimeZone(_ identifier: String) {
        timeZones.removeAll { $0.identifier == identifier }
    }
    
    /// Get current time in a specific time zone
    func getCurrentTime(for timeZoneInfo: TimeZoneInfo) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZoneInfo.timeZone
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    /// Get current date in a specific time zone
    func getCurrentDate(for timeZoneInfo: TimeZoneInfo) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZoneInfo.timeZone
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        return dateFormatter.string(from: Date())
    }
    
    /// Display all time zones with current times
    func displayAllTimeZones() {
        print("\n" + String(repeating: "=", count: 60))
        print("WORLD CLOCK - \(getCurrentDate(for: timeZones.first ?? TimeZoneInfo(identifier: "UTC", displayName: "UTC", abbreviation: "UTC")))")
        print(String(repeating: "=", count: 60))
        
        for timeZone in timeZones {
            let time = getCurrentTime(for: timeZone)
            let displayName = timeZone.displayName
            print("|\(String(format: "%-35s", displayName))| \(time) |")
        }
        
        print(String(repeating: "=", count: 60) + "\n")
    }
    
    /// Start continuous clock update
    func startClock(updateInterval: TimeInterval = 1.0) {
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.displayAllTimeZones()
        }
    }
    
    /// Stop continuous clock update
    func stopClock() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Get all available time zones
    static func getAllTimeZones() -> [String] {
        return TimeZone.knownTimeZoneIdentifiers
    }
    
    /// Search for time zones by city or country name
    static func searchTimeZones(query: String) -> [TimeZoneInfo] {
        let searchQuery = query.lowercased()
        let results = TimeZone.knownTimeZoneIdentifiers
            .filter { $0.lowercased().contains(searchQuery) }
            .map { identifier in
                TimeZoneInfo(
                    identifier: identifier,
                    displayName: identifier.replacingOccurrences(of: "_", with: " "),
                    abbreviation: TimeZone(identifier: identifier)?.abbreviation() ?? "UTC"
                )
            }
        return results
    }
}
