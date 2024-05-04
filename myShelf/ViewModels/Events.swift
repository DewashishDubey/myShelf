import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    var id: String
    var address: String
    var capacity: Int
    var guest: String
    var room: String
    var selectedDate: String
    var selectedTime: String
    var summary: String
    var title: String
    var uid: String
}

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    private var db = Firestore.firestore()
    
    func fetchEvents() {
        db.collection("events").addSnapshotListener{ querySnapshot, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            var fetchedEvents: [Event] = []
            let dispatchGroup = DispatchGroup()
            for document in documents {
                dispatchGroup.enter()
                let data = document.data()
                guard let address = data["address"] as? String,
                      let capacity = data["capacity"] as? Int,
                      let guest = data["guest"] as? String,
                      let room = data["room"] as? String,
                      let selectedDateTimestamp = data["selectedDate"] as? Timestamp,
                      let selectedTimeTimestamp = data["selectedTime"] as? Timestamp,
                      let summary = data["summary"] as? String,
                      let title = data["title"] as? String,
                      let uid = data["uid"] as? String else {
                          print("Error parsing event data for document \(document.documentID). Data: \(data)")
                          dispatchGroup.leave()
                          continue
                      }
                
                let selectedDate = self.formatDate(selectedDateTimestamp.dateValue())
                let selectedTime = self.formatDate(selectedTimeTimestamp.dateValue())
                
                let event = Event(id: document.documentID,
                                  address: address,
                                  capacity: capacity,
                                  guest: guest,
                                  room: room,
                                  selectedDate: selectedDate,
                                  selectedTime: selectedTime,
                                  summary: summary,
                                  title: title,
                                  uid: uid)
                
                fetchedEvents.append(event)
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.events = fetchedEvents
            }
        }
    }
    
    func fetchEvent(forUID uid: String) {
        db.collection("events").whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching event for UID \(uid): \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found for UID \(uid)")
                return
            }
            
            guard let document = documents.first else {
                print("No event found for UID \(uid)")
                return
            }
            
            var fetchedEvents: [Event] = []
            let dispatchGroup = DispatchGroup()
            for document in documents {
                dispatchGroup.enter()
                let data = document.data()
                guard let address = data["address"] as? String,
                      let capacity = data["capacity"] as? Int,
                      let guest = data["guest"] as? String,
                      let room = data["room"] as? String,
                      let selectedDateTimestamp = data["selectedDate"] as? Timestamp,
                      let selectedTimeTimestamp = data["selectedTime"] as? Timestamp,
                      let summary = data["summary"] as? String,
                      let title = data["title"] as? String,
                      let uid = data["uid"] as? String else {
                    print("Error parsing event data for document \(document.documentID). Data: \(data)")
                    dispatchGroup.leave()
                    continue
                }
                
                let selectedDate = self.formatDate(selectedDateTimestamp.dateValue())
                let selectedTime = self.formatDate(selectedTimeTimestamp.dateValue())
                
                let event = Event(id: document.documentID,
                                  address: address,
                                  capacity: capacity,
                                  guest: guest,
                                  room: room,
                                  selectedDate: selectedDate,
                                  selectedTime: selectedTime,
                                  summary: summary,
                                  title: title,
                                  uid: uid)
                
                fetchedEvents.append(event)
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                self.events = fetchedEvents
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm:ss a"
        return formatter.string(from: date)
    }
}
