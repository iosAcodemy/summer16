//
//  FeedViewControllerSpec.swift
//  spotifyAcodemy
//
//  Created by Krzysztof on 23.06.2016.
//  Copyright © 2016 10Clouds. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable
import spotifyAcodemy

class FeedViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: FeedViewController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Feed", bundle: nil)
            sut = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
        }

        describe("navigation title") {
            it("should be set") {
                expect(sut.showResults).to(beFalse())
            }
        }

        afterEach {
            sut = nil
        }
    }
}
