//
// Created by Tomasz Mędryk on 08/04/16.
// Copyright (c) 2016 10Clouds. All rights reserved.
//

import Foundation

enum Response<T> {
    case Success(T)
    case Error(NSError?)
}
