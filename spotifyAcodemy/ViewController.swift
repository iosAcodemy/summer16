//
//  ViewController.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 30.03.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let itemService = SpotifyItemService()
        let albumService = AlbumService()
        let artistService = ArtistService()

        let trackIds = ["7ITDSDsHFSe5LG4PrGjsFq", "7lmeHLHBe4nmXzuXc0HDjk", "4JCNBdBmMMKouIJywdv1RG"]
        let albumIds = ["1lhoN3qbSRxfSEm6I2t8cK", "2eia0myWFgoHuttJytCxgX", "5Zg3yBhle2mHVpTFfmwqZV"]
        let artistsIds = ["6Tyzp9KzpiZ04DABQoedps", "2d0hyoQ5ynDBnkvAbJKORj", "5i5XueTDXZlHhWyEfeE8dv"]

//        itemService.getItems(artistsIds) { (response: Response<[Artist]>) in
//            switch response {
//            case .Success(let items, _):
//                debugPrint(items)
//            case .Error(let error):
//                debugPrint(error)
//            }
//        }

//        itemService.getItem("6Tyzp9KzpiZ04DABQoedps") { (response: Response<Artist>) in
//            switch response {
//            case .Success(let item, _):
//                debugPrint(item)
//            case .Error(let error):
//                debugPrint(error)
//            }
//        }

//        itemService.searchFor("Bob Dylan") { (response: Response<[Artist]>) in
//            switch response {
//                case .Success(let items, _):
//                    debugPrint(items)
//                case .Error(let error):
//                    debugPrint(error)
//            }
//        }

        albumService.getTracks("1lhoN3qbSRxfSEm6I2t8cK") { (response: Response<[Track]>) in
            switch response {
                case .Success(let items):
                    debugPrint(items)
                case .Error(let error):
                    debugPrint(error)
            }
        }

//        artistService.getAlbums("6Tyzp9KzpiZ04DABQoedps") { (response: Response<[Album]>) in
//            switch response {
//                case .Success(let items, _):
//                    debugPrint(items)
//                case .Error(let error):
//                    debugPrint(error)
//            }
//        }

//        artistService.getRelatedArtists("6Tyzp9KzpiZ04DABQoedps") { (response: Response<[Artist]>) in
//            switch response {
//            case .Success(let items, _):
//                debugPrint(items)
//            case .Error(let error):
//                debugPrint(error)
//            }
//        }

//        artistService.getTopTracks("6Tyzp9KzpiZ04DABQoedps", countryCode: "US") { (response: Response<[Track]>) in
//            switch response {
//            case .Success(let items, _):
//                debugPrint(items)
//            case .Error(let error):
//                debugPrint(error)
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
