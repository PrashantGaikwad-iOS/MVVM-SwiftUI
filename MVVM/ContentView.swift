//
//  ContentView.swift
//  MVVM
//
//  Created by Saif on 30/09/19.
//  Copyright © 2019 LeftRightMind. All rights reserved.
//

import SwiftUI

let apiUrlString = "https://api.letsbuildthatapp.com/static/courses.json"

struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let price: Int
}

class CourseViewModel: ObservableObject {
    
    @Published var courses: [Course] = [
        .init(name: "Course 1", price: 40),
        .init(name: "Course 2", price: 20),
        .init(name: "Course 3", price: 80),
        .init(name: "Course 4", price: 50)
    ]
    
    func fetchCourses() {
        
        guard let url = URL(string: apiUrlString) else {
            fatalError("Bad Url")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                fatalError("Error occured")
            }
            do {
                self.courses = try JSONDecoder().decode([Course].self, from: data!)
            }
            catch {
                print("Failed to decode JSON",error)
            }
        }.resume()
        
    }
    
}

struct ContentView: View {
    
    @ ObservedObject var coursesVM = CourseViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    ForEach(coursesVM.courses) { course in
                        HStack {
                            Text(course.name)
                                .font(.system(size:20))
                                .fontWeight(.semibold)
                                .padding(.leading,2)
                            Spacer()
                        }
                        .padding(.bottom,4)
                        Text("Price: $\(course.price)")
                            .padding(.leading,2)
                    }
                }
                .padding(.horizontal,22)
                .padding(.top,8)
            }
            
                
            .navigationBarTitle(Text("Courses"))
            .navigationBarItems(trailing: Button(action: {
                print("Fetch the data")
                self.coursesVM.fetchCourses()
            }, label: {
                Text("Fetch Courses")
            }))
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
