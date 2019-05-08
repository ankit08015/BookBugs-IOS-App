//
//  XMLParser.swift
//  BookReviewApp
//
//  Created by administrator on 4/26/19.
//  Copyright © 2019 ios-development. All rights reserved.
//
import Foundation

// download xml from a server
// parse xml to foundation objects
// call back


// download xml from a server
// parse xml to foundation objects
// call back

class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentAuthor: String = "" {
        didSet {
            currentAuthor = currentAuthor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentRating: String = "" {
        didSet {
            currentRating = currentRating.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImageSmall: String = "" {
        didSet {
            currentImageSmall = currentImageSmall.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentImageLarge: String = "" {
        didSet {
            currentImageLarge = currentImageSmall.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            /// parse our xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "work" {
            currentTitle = ""
            currentAuthor = ""
            currentPubDate = ""
            currentRating = ""
            currentImageLarge = ""
            currentImageSmall = ""
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "name" : currentAuthor += string
        case "image_url" : currentImageLarge += string
        case "small_image_url" : currentImageSmall += string
        case "original_publication_year" : currentPubDate += string
        case "average_rating" : currentRating += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "work" {
            let rssItem = RSSItem(title: currentTitle, author: currentAuthor, pubDate: currentPubDate, imageSmall: currentImageSmall, imageLarge: currentImageLarge, avgRating : currentRating)
            self.rssItems.append(rssItem)
            AppDelegate.bookList.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
}

