
import Foundation

// Runs query data task, and stores results in array of Tracks
class QueryService {

  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Track]?, String) -> ()

  var tracks: [Track] = []
  var errorMessage = ""
	
	// a default session is supposed to persist to disk
	let defaultSession = URLSession(configuration: .default)
	var dataTask: URLSessionDataTask?

  func getSearchResults(searchTerm: String, completion: @escaping QueryResult)
	{
		// start by cancelling the data task from a previous search
    dataTask?.cancel()
		
		// use URLComponents to construct the url from its parts
		if var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
		{
			urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
			
			guard let url = urlComponents.url else { return }
			
			dataTask = defaultSession.dataTask(with: url)
			{ data, response, error in
				defer { self.dataTask = nil }
				
				if let error = error
				{
					self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				}
				else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200
				{
					// this helper method parses the data into the tracks array
					self.updateSearchResults(data)
					
					DispatchQueue.main.async
					{ // this is a communication pattern
						// the block code is generic (to be defined in the method call)
						// but the arguments are specific (the downloaded data: the tracks)
						completion(self.tracks, self.errorMessage)
					}
				}
			} // end of data task
			
			dataTask?.resume()
		}
  }

  fileprivate func updateSearchResults(_ data: Data)
	{
    var response: JSONDictionary?
    tracks.removeAll()

    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }

    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }
    var index = 0
    for trackDictionary in array {
      if let trackDictionary = trackDictionary as? JSONDictionary,
        let previewURLString = trackDictionary["previewUrl"] as? String,
        let previewURL = URL(string: previewURLString),
        let name = trackDictionary["trackName"] as? String,
        let artist = trackDictionary["artistName"] as? String {
        tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
        index += 1
      } else {
        errorMessage += "Problem parsing trackDictionary\n"
      }
    }
  }

}
