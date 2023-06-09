//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by TheForce on 5/16/23.
//

import Foundation

@MainActor
class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String // TODO: We'll want to change this to an optional
        var results: [Creature]
    }

    

    
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        // convert urlString to a special URL type 
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structures
            guard let returned = try?  JSONDecoder().decode(Returned.self, from: data) else {
                
                print("😡 JSON ERROR: Could not decode returned JSON data")
                return
            }
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
            // TODO: Decode JSON into class's properties
        } catch {
            print("😡 ERROR: Could not get user URL at \(urlString) to get data and response")
        }
        
    }
    
}
