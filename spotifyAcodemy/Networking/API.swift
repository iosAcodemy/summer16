//
// Created by Tomasz Mędryk on 05/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

//
//GET https://api.spotify.com/v1/tracks/0eGsygTp906u18L0Oimnem
//
//GET https://api.spotify.com/v1/artists/43ZHCT0cAZBISjO8DG9PnE/top-tracks?country=PL
//
//GET https://api.spotify.com/v1/search?q=%22doom%20metal%22&type=playlist
//
//GET https://api.spotify.com/v1/search?q=tania%20bowra&type=artist
//
//GET https://api.spotify.com/v1/albums/6akEvsycLGftJxYudPjmqK/tracks?limit=2
//
//GET https://api.spotify.com/v1/albums/?ids=41MnTivkwTO3UUJ8DrqEJJ,6JWc4iAiJ9FjyK0B59ABb4,6UXCm6bOO4gFlDQZV5yL37
//
//GET https://api.spotify.com/v1/tracks/?ids=0eGsygTp906u18L0Oimnem,1lDWb6b6ieDQ2xT7ewTC3G
//
//GET https://api.spotify.com/v1/albums/0sNOF9WDwhWunNAHPD3Baj
//
//GET https://api.spotify.com/v1/search?q=abba&type=track&market=US
//
//GET https://api.spotify.com/v1/users/tuggareutangranser
//
//GET https://api.spotify.com/v1/artists/0OdUWJ0sBjDrqHygGUXeCF
//
//GET https://api.spotify.com/v1/artists/43ZHCT0cAZBISjO8DG9PnE/related-artists
//
//GET https://api.spotify.com/v1/search?q=album:arrival%20artist:abba&type=album
//
//GET https://api.spotify.com/v1/artists/1vCWHaC5f2uS3yhpwWbIA6/albums?market=ES&album_type=single&limit=2

import Foundation

let api = API()

class API {

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    enum Endpoint {
		case Track(id: String)
		case Tracks(ids: [String])
        case Album(id: String)
        case AlbumTracks(id: String)
        case Albums(ids: [String])
        case Artist(id: String)
        case ArtistAlbums(id: String)
        case ArtistTopTracks(id: String, countryCode: String)
        case ArtistRelatedArtists(id: String)
        case Artists(ids: [String])
        case Search(query: String, type: SpotifyItemType)

        var method: HTTPMethod {
            switch self {
            default:
                return .GET
            }
        }
        // Module 1 - Task 1
        var path: String {
            switch self {
            case .Album(let id):
                return "albums/\(id)/"
            case .AlbumTracks(let id):
                return "albums/\(id)/tracks/"
            case .Albums:
                return "albums/"
            case .Artist(let id):
                return "artists/\(id)/"
            case .ArtistAlbums(let id):
                return "artists/\(id)/albums/"
            case .ArtistTopTracks(let id, _):
                return "artists/\(id)/top-tracks/"
            case .ArtistRelatedArtists(let id):
                return "artists/\(id)/related-artists/"
            case .Artists:
                return "artists/"
            case .Search:
                return "search/"
			default:
				return ""
            }
        }

        var parameters: [String: AnyObject] {
            var parameters = [String: AnyObject]()
            switch self {
            case .Albums(let ids):
                parameters["ids"] = ids.encoded
            case .Artists(let ids):
                parameters["ids"] = ids.encoded
            case .ArtistTopTracks(_, let countryCode):
                parameters["country"] = countryCode
            case .Search(let query, let type):
                parameters["query"] = query
                parameters["type"] = type.rawValue
            default:
                break
            }
            return parameters
        }

        var rootKeyPath: String? {
            switch self {
            case .ArtistTopTracks:
                return "tracks"
            case .Albums:
                return "albums"
            case .Artists, .ArtistRelatedArtists:
                return "artists"
            case .AlbumTracks, .ArtistAlbums:
                return "items"
            case .Search(_, let type):
                return "\(type.rawValue)s.items"
            default:
                return nil
            }
        }
    }

    // MARK: Properties

    static let baseURL = NSURL(string: "https://api.spotify.com/v1/")!

    private let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    // MARK: Public API

    func requestObject<T: JSONDecodable>(endpoint: Endpoint, completionHandler: (Response<T>) -> Void) {
        request(endpoint) { json, error in
            if let json = json, object: T = self.decodeJSON(json, rootKeyPath: endpoint.rootKeyPath) {
                completionHandler(Response.Success(object))
            } else {
                completionHandler(Response.Error(error))
            }
        }
    }

    func requestObjects<T: JSONDecodable>(endpoint: Endpoint, completionHandler: (Response<[T]>) -> Void) {
        request(endpoint) { json, error in
            if let json = json, object: [T] = self.decodeJSONArray(json, rootKeyPath: endpoint.rootKeyPath) {
                completionHandler(Response.Success(object))
            } else {
                completionHandler(Response.Error(error))
            }
        }
    }

    func request(endpoint: Endpoint, completionHandler: (json: JSON?, error: NSError?) -> Void) {
        //Module 1 - Task 2
    }

    func createNSErrorFromJson(json: JSON?) -> NSError? {
        guard let dict = json,
            errorDict = dict["error"] as? [String: AnyObject],
            message = errorDict["message"] as? String,
            errorCode = errorDict["status"] as? Int
            else { return nil }

        var userInfoDict = [String:String]()
        userInfoDict[NSLocalizedDescriptionKey] = message
        return NSError(domain: "iosAcodemy", code: errorCode, userInfo: userInfoDict)
    }

    // MARK: Private Methods

    private func absoluteURL(endpoint: Endpoint) -> NSURL? {
        //Module 1 - Task 3
		return nil
    }

    private func decodeJSON<T: JSONDecodable>(json: JSON, rootKeyPath: String?) -> T? {
        guard let jsonObject = rootObject(json, rootKeyPath: rootKeyPath) else {
            return nil
        }

        return try? T.decodeJSONObject(jsonObject)
    }

    private func decodeJSONArray<T: JSONDecodable>(json: JSON, rootKeyPath: String?) -> [T]? {
        guard let jsonObject = rootObject(json, rootKeyPath: rootKeyPath) else {
            return nil
        }

        return try? Array<T>.decodeJSONObject(jsonObject)
    }

    private func rootObject(json: JSON, rootKeyPath: String?) -> AnyObject? {
        guard let keyPath = rootKeyPath where !keyPath.isEmpty else {
            return json
        }

        let subpaths = keyPath.componentsSeparatedByString(".")
        let subpathsCount = subpaths.count

        var rootJSON: JSON? = json
        for (index, subpath) in subpaths.enumerate() {
            if let obj = rootJSON?[subpath] {
                if index < subpathsCount - 1 {
                    rootJSON = obj as? JSON
                } else {
                    return obj
                }
            } else {
                return nil
            }
        }
        
        return nil
    }
}
