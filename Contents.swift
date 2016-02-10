//: Playground - noun: a place where people can play

/* A very basic example of Neworking in Swift using NSSession
   and the ever-entertaining Chuck Norris api.
*/

import XCPlayground
import Foundation

let page = XCPlaygroundPage.currentPage
page.needsIndefiniteExecution = true


func getJoke() -> String? {
    
    guard let url = NSURL(string: "http://api.icndb.com/jokes/random") else { return nil }
    let request = NSURLRequest(URL: url)
    
    httpGet(request) { (data, error) -> Void in
        if error != nil {
            print(error)
        } else {
            print("data: \(data)")
            guard let joke = dataToJokeString(data!) else { return }
            print("Joke: \(joke)")
        }
    }
    
    return "Blah"
}


func dataToJokeString(data: NSData) -> String? {
    do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        guard
            let value = json["value"] as? NSMutableDictionary,
            let joke = value["joke"] as? String
            else { return "Failed to deserialize" }
        return joke
    } catch {
        return "Error"
    }
}


func httpGet(request: NSURLRequest, callback: (NSData?, NSError?) -> Void ) {
    let session = NSURLSession.sharedSession()

    let task = session.dataTaskWithRequest(request) {
        (data, response, error) -> Void in
        if error != nil {
            callback(nil, error)
        } else {
            callback(data, nil)
        }
        
    }
    
    task.resume()

}


getJoke()
