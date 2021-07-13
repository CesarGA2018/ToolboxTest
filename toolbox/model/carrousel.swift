//
//  carrousel.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import Foundation

// MARK: - WelcomeElement
struct Carrousell: Codable {
    let title, type: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let imageURL: String
    let videoURL: String?
    let itemDescription: String
    var type: String?

    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "imageUrl"
        case videoURL = "videoUrl"
        case itemDescription = "description"
        case type
    }
}
