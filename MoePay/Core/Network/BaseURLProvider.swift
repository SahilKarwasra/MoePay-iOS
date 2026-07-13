//
//  BaseURLProvider.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 13/07/26.
//

import Foundation

protocol BaseURLProvider {
    var baseURL: URL { get }
}

struct DefaultBaseURLProvider: BaseURLProvider {
    var baseURL: URL {
        URL(string: "http://127.0.0.1:8080/api/v1/")!
    }
}
