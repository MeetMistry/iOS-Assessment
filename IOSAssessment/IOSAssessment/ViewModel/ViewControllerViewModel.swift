//
//  ViewControllerViewModel.swift
//  IOSAssessment
//
//  Created by Meet Mistry on 01/05/24.
//

import Foundation

class ViewControllerViewModel: NSObject {
    
    // MARK: -
    // MARK: - Functions
    
    func getImagesFromServer(completion: @escaping ([ImageModel]) -> ()) {
        let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print("THERE IS SOMETHING WRONG: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with response, unexpected status code: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("data not found")
                return
            }
            
            do {
                let listOfImages = try JSONDecoder().decode([ImageModel].self, from: data)
                completion(listOfImages)
            } catch {
                print("ERROR DECODING JSON: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
}// End of Class
