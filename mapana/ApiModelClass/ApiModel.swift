//
//  ApiModel.swift
//  mapana
//
//  Created by Naman Sheth on 15/07/23.
//

import Foundation
import UIKit

// MARK: - LoginAPI
struct LoginAPI: Codable {
    let username: String?
    let id, userRoleID: Int?
    let userRole: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case username, id
        case userRoleID
        case userRole
        case imageURL
    }
}

// MARK: - BoroughAllElement
struct BoroughAllElement: Codable {
    let created, updated: String?
    let id: Int?
    let name: String?
}

typealias BoroughAll = [BoroughAllElement]



// MARK: - BoroughLocationElement
struct BoroughLocationElement: Codable {
    let referenceId: String?
    let link: String?
    let lat, lng: String?
    let color: JSONNull?
    let icon: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case referenceId
        case link, lat, lng, color, icon, id
    }
}

typealias BoroughLocation = [BoroughLocationElement]


// MARK: - BoroughRouteElement
struct BoroughRouteElement: Codable {
    let jobs: [Job]
//    let depots: [JSONAny]
    let options: Options
    let vehicles: [Vehicle]
    let locations: Locations
//    let shipments: [JSONAny]
}

typealias BoroughRoute = BoroughRouteElement
// MARK: - Job
struct Job: Codable {
    let skills: [Int]
    let locationIndex: Int
    let description: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case skills
        case locationIndex = "location_index"
        case description, id
    }
}

// MARK: - Locations
struct Locations: Codable {
    let location: [String]
    let id: Int
}

// MARK: - Options
struct Options: Codable {
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let skills, timeWindow: [Int]
    let startIndex: Int
    let description: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case skills
        case timeWindow = "time_window"
        case startIndex = "start_index"
        case description, id
    }
}

// MARK: - RouteMatrixElement
struct RouteMatrixElement: Codable {
    var originIndex, destinationIndex: Int?
    var status: Status?
    var distanceMeters: Int?
    var duration, condition: String?
}

// MARK: - Status
struct Status: Codable {
}

typealias RouteMatrix = [RouteMatrixElement]

// MARK: - GoogleRoute
struct GoogleRoute: Codable {
    let routes: [Routee]?
}

// MARK: - Route
struct Routee: Codable {
    let distanceMeters: Int?
    let duration: String?
    let polyline: Polyline?
}

// MARK: - Polyline
struct Polyline: Codable {
    let encodedPolyline: String?
}

// MARK: - SurveyImageElement
struct SurveyImageElement: Codable {
    var created, updated: String?
    var id, signID: Int?
    var mediaUrl: String?
    var mediaType, signStatus: String?
    var lat, lng, type: String?

    enum CodingKeys: String, CodingKey {
        case created, updated, id
        case signID
        case mediaUrl
        case mediaType, signStatus, lat, lng, type
    }
}

typealias SurveyImage = [SurveyImageElement]

// MARK: - SurveyComment
struct SurveyComment: Codable {
    var userID, comID: Int?
    var fullName, text: String?
    var avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case userID
        case comID
        case fullName, text
        case avatarUrl
    }
}

typealias SurveyComments = [SurveyComment]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
