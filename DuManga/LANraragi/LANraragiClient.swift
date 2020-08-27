//  Created 22/8/20.

import Foundation
import Alamofire
import AlamofireImage
import Logging

class LANRaragiClient {
    static let logger = Logger(label: "LANRaragiClient")
    
    let url: String
    let auth: String
    let imageDownloader = ImageDownloader()
    
    init(url: String, apiKey: String) {
        self.url = url
        self.auth = apiKey.data(using: .utf8)!.base64EncodedString()
    }
    
    func getArchiveIndex(completionHandler: @escaping ([ArchiveIndexResponse]?) -> Void)  {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        AF.request("\(url)/api/archives", headers: headers)
            .validate()
            .responseDecodable(of: [ArchiveIndexResponse].self) { response in
                if let archiveIndex = response.value {
                    completionHandler(archiveIndex)
                } else {
                    LANRaragiClient.logger.error("Error retrieving the index. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
        }
    }
    
    func getArchiveMetadata(id: String, completionHandler: @escaping (ArchiveIndexResponse?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        AF.request("\(url)/api/archives/\(id)/metadata", headers: headers)
            .validate()
            .responseDecodable(of: ArchiveIndexResponse.self) { response in
                if let archiveMetadata = response.value {
                    completionHandler(archiveMetadata)
                } else {
                    LANRaragiClient.logger.error("Error retrieving archive metadata. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
        }
    }
    
    func getArchiveThumbnail(id: String, completionHandler: @escaping (Image?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        ImageResponseSerializer.addAcceptableImageContentTypes(["application/x-download"])
        do {
            let request = try URLRequest(url: "\(url)/api/archives/\(id)/thumbnail", method: .get, headers: headers)
            imageDownloader.download(request) { response in
                if let thumbnail = response.value {
                    completionHandler(thumbnail)
                } else {
                    LANRaragiClient.logger.error("Faile to retrieve thumbnail. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
            }
        } catch {
            LANRaragiClient.logger.error("Error retrieving thumbnail. \(error)")
            completionHandler(nil)
        }
    }
    
    func postArchiveExtract(id: String, completionHandler: @escaping (ArchiveExtractResponse?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        AF.request("\(url)/api/archives/\(id)/extract", method: .post, headers: headers)
            .validate()
            .responseDecodable(of: ArchiveExtractResponse.self) { response in
                if let pages = response.value {
                    completionHandler(pages)
                } else {
                    LANRaragiClient.logger.error("Error extracting archive. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
        }
    }
    
    func getArchivePage(page: String, completionHandler: @escaping (Image?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        ImageResponseSerializer.addAcceptableImageContentTypes(["application/x-download"])
        do {
            let request = try URLRequest(url: "\(url)/\(page)", method: .get, headers: headers)
            imageDownloader.download(request) { response in
                if let page = response.value {
                    completionHandler(page)
                } else {
                    LANRaragiClient.logger.error("Faile to retrieve page. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
            }
        } catch {
            LANRaragiClient.logger.error("Error retrieving page. \(error)")
            completionHandler(nil)
        }
    }
    
    func getCategories(completionHandler: @escaping ([ArchiveCategoriesResponse]?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        AF.request("\(url)/api/categories", headers: headers)
            .validate()
            .responseDecodable(of: [ArchiveCategoriesResponse].self) { response in
                if let archiveCategories = response.value {
                    completionHandler(archiveCategories)
                } else {
                    LANRaragiClient.logger.error("Error retrieving archive categories. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
        }
    }
    
    func searchArchiveIndex(category: String? = nil,
                            filter: String? = nil,
                            start: String? = nil,
                            sortby: String? = nil,
                            order: String? = nil,
                            completionHandler: @escaping (ArchiveSearchResponse?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth)"
        ]
        var query = [String: String]()
        if category != nil {
            query["category"] = category
        }
        if filter != nil {
            query["filter"] = filter
        }
        if start != nil {
            query["start"] = start
        }
        if sortby != nil {
            query["sortby"] = sortby
        }
        if order != nil {
            query["order"] = order
        }
        
        AF.request("\(url)/api/search", parameters: query, headers: headers)
            .validate()
            .responseDecodable(of: ArchiveSearchResponse.self) { response in
                if let archiveSearchResult = response.value {
                    completionHandler(archiveSearchResult)
                } else {
                    LANRaragiClient.logger.error("Error search archive. response=\"\(response.debugDescription)\"")
                    completionHandler(nil)
                }
        }
    }
    
}

