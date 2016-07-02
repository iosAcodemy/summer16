//
//  AlbumViewControllerSpec.swift
//  spotifyAcodemy
//
//  Created by Patryk Mierzejewski on 30.06.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable
import spotifyAcodemy

class AlbumViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: AlbumViewController!
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Album", bundle: nil)
            sut = storyboard.instantiateViewControllerWithIdentifier("albumViewController") as! AlbumViewController
        }
        
        describe("navigation title") {
            beforeEach {
                let album = Album(id: "1Eo1pg2D4beFgf3HFTJTMc", name: "Hello", href: "https://api.spotify.com/v1/albums/1Eo1pg2D4beFgf3HFTJTMc", albumTypeRaw: "single", images: [Image(width: 300, height: 300, url: "spotify:track:0ENSn4fwAbCGeFGVUbXEU3")], artists: nil, genres: nil, popularity: nil, releaseDate: nil, tracks: nil, typeRaw: "artist", uri: "spotify:track:0ENSn4fwAbCGeFGVUbXEU3")
                sut.album = album
                let _ = sut.view
            }
            
            it("should be set") {
                expect(sut.title).toNotEventually(beNil())
            }
            
            it("should display Album's name") {
                expect(sut.title).toEventually(equal("Hello"))
            }
        }
        afterEach {
            sut = nil
        }
    }
}
