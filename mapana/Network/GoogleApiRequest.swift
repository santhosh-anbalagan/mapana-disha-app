//
//  GoogleApiRequest.swift
//  mapana
//
//  Created by Naman Sheth on 21/07/23.
//


import UIKit
import Foundation

struct DirectionResponse: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let legs: [Leg]
}

struct Leg: Codable {
    let distance: Distance
    let end_location: Location
}

struct Distance: Codable {
    let value: Int
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

func findFurthestPoint(currentLocation: (Double, Double), waypoints: [(Double, Double)], apiKey: String) {
    let origin = "\(currentLocation.0),\(currentLocation.1)"
    let destination = "\(waypoints[0].0),\(waypoints[0].1)"
    let otherWaypoints = waypoints.dropFirst().map { "\($0.0),\($0.1)" }.joined(separator: "|")
    let waypointsParam = "waypoints=optimize:true|\(destination)|\(otherWaypoints)"
    
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&\(waypointsParam)&key=\(apiKey)"
    print(urlString)
    if let url2 = URL(string: urlString) {
        URLSession.shared.dataTask(with: url2) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DirectionResponse.self, from: data)
                
                if let furthestSegment = response.routes.first?.legs.max(by: { $0.distance.value < $1.distance.value }) {
                    let furthestPoint = furthestSegment.end_location
                    let distance = furthestSegment.distance.value
                    print("Furthest Point: (\(furthestPoint.lat), \(furthestPoint.lng))")
                    print("Distance from Current Location: \(distance) meters")
                } else {
                    print("No furthest point found.")
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    } else {
        print("Invalid URL")
    }
//    guard let url = URL(string: urlString) else {
//        print("Invalid URL")
//        return
//    }
    
   
}


//findFurthestPoint(currentLocation: currentLocation, waypoints: waypoints, apiKey: apiKey)

//
//
//
//        ("51.38055624962682","-0.2449738120937638"),("51.35765303565484", "-0.21707807036698326"),
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 1821
//    },
//    {
//        "referenceId": "STEX003",
//        "lat": "51.35765303565484",
//        "lng": "-0.21707807036698326",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 1820
//    },
//    {
//        "referenceId": "STEX002",
//        "lat": "51.355306250158435",
//        "lng": "-0.2121954507876851",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 1809
//    },
//    {
//        "referenceId": "STABS013",
//        "lat": "51.34668772257639",
//        "lng": "-0.20559548596784588",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 1803
//    },
//    {
//        "referenceId": "STBR005",
//        "link": "https://www.google.com/maps/@51.3437792,-0.1943768,3a,90y,265.09h,104.02t/data=!3m7!1e1!3m5!1svYsxgg5jET9lhQgbzFhWUQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DvYsxgg5jET9lhQgbzFhWUQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D44.33488%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3437792",
//        "lng": "-0.1943768",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 109
//    },
//    {
//        "referenceId": "STB001",
//        "link": "https://www.google.com/maps/@51.3341758,-0.1678243,3a,75y,108.18h,82.82t/data=!3m7!1e1!3m5!1sgI00DZc0QHtGodAzlbwKJg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DgI00DZc0QHtGodAzlbwKJg%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D190.40936%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3341758",
//        "lng": "-0.1678243",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 108
//    },
//    {
//        "referenceId": "STB002",
//        "link": "https://www.google.com/maps/@51.3341758,-0.1678243,3a,49.5y,25.55h,90.67t/data=!3m6!1e1!3m4!1sgI00DZc0QHtGodAzlbwKJg!2e0!7i16384!8i8192",
//        "lat": "51.3341758",
//        "lng": "-0.1678243",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 107
//    },
//    {
//        "referenceId": "STBR002",
//        "link": "https://www.google.com/maps/@51.3350115,-0.1669164,3a,90y,269.08h,99.14t/data=!3m6!1e1!3m4!1s4Cq1IXST5jjdIVkLkBr9rw!2e0!7i16384!8i8192",
//        "lat": "51.3350115",
//        "lng": "-0.1669164",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 106
//    },
//    {
//        "referenceId": "STBR001",
//        "link": "https://www.google.com/maps/@51.3350185,-0.1661512,3a,63.7y,295.62h,99.43t/data=!3m6!1e1!3m4!1s_slkxygAakBLGtm7sUlHOQ!2e0!7i16384!8i8192",
//        "lat": "51.3350185",
//        "lng": "-0.1661512",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 105
//    },
//    {
//        "referenceId": "STABS001",
//        "link": "https://www.google.com/maps/@51.3347655,-0.1690874,3a,41.3y,103.05h,80.56t/data=!3m6!1e1!3m4!1s5iAGpmfFizMHfZcyGFX06w!2e0!7i16384!8i8192",
//        "lat": "51.3347655",
//        "lng": "-0.1690874",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 104
//    },
//    {
//        "referenceId": "STB004",
//        "link": "https://www.google.com/maps/@51.3348131,-0.1674731,3a,75y,19.5h,84.23t/data=!3m7!1e1!3m5!1s7XG5S_9O6JgyffHtqWGMGw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D7XG5S_9O6JgyffHtqWGMGw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D117.632706%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3348131",
//        "lng": "-0.1674731",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 103
//    },
//    {
//        "referenceId": "STB003",
//        "link": "https://www.google.com/maps/@51.3346049,-0.1675023,3a,49.5y,47.14h,85.81t/data=!3m6!1e1!3m4!1sPuZKAIc-Eew1J5VvO-yiqA!2e0!7i16384!8i8192",
//        "lat": "51.3346049",
//        "lng": "-0.1675023",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 102
//    },
//    {
//        "referenceId": "STB005",
//        "link": "https://www.google.com/maps/@51.3418661,-0.1686216,3a,75y,70.66h,85.74t/data=!3m6!1e1!3m4!1stYQ557cxNwvcWAqxa5LI6w!2e0!7i16384!8i8192",
//        "lat": "51.3418661",
//        "lng": "-0.1686216",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 101
//    },
//    {
//        "referenceId": "STBLLCS001",
//        "link": "https://www.google.com/maps/@51.3429349,-0.1942393,3a,83.4y,114.14h,90.65t/data=!3m6!1e1!3m4!1sah8t3lbhjILjoRzRDgDCQw!2e0!7i16384!8i8192",
//        "lat": "51.3429349",
//        "lng": "-0.1942393",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 100
//    },
//    {
//        "referenceId": "STB006",
//        "link": "https://www.google.com/maps/@51.3430204,-0.1942579,3a,75y,287.43h,82.87t/data=!3m6!1e1!3m4!1s9BNRUMGA_qTsU_SKaxsKtg!2e0!7i16384!8i8192",
//        "lat": "51.3430204",
//        "lng": "-0.1942579",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 99
//    },
//    {
//        "referenceId": "STAn001",
//        "link": "https://www.google.com/maps/@51.3430454,-0.1947884,3a,48.4y,308.11h,93t/data=!3m6!1e1!3m4!1sKsYgXvYCDWjefW6-Gu7JFw!2e0!7i13312!8i6656",
//        "lat": "51.3430454",
//        "lng": "-0.1947884",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 98
//    },
//    {
//        "referenceId": "STBR004",
//        "link": "https://www.google.com/maps/@51.3429349,-0.1942393,3a,15y,114.13h,91.79t/data=!3m6!1e1!3m4!1sah8t3lbhjILjoRzRDgDCQw!2e0!7i16384!8i8192",
//        "lat": "51.3429349",
//        "lng": "-0.1942393",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 97
//    },
//    {
//        "referenceId": "STBR007",
//        "link": "https://www.google.com/maps/@51.3446216,-0.1973184,3a,90y,306.06h,102.53t/data=!3m7!1e1!3m5!1sfNpefa8-0srBoF7IA4uP9A!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DfNpefa8-0srBoF7IA4uP9A%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D17.611387%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3446216",
//        "lng": "-0.1973184",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 96
//    },
//    {
//        "referenceId": "STB007",
//        "link": "https://www.google.com/maps/@51.3441003,-0.1977161,3a,90y,321.61h,82.2t/data=!3m7!1e1!3m5!1sXI1SEx3Ak9IRaqSbQPfVJQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DXI1SEx3Ak9IRaqSbQPfVJQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D34.472095%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3441003",
//        "lng": "-0.1977161",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 95
//    },
//    {
//        "referenceId": "STABS003A",
//        "link": "https://www.google.com/maps/@51.3437362,-0.1980093,3a,90y,272.39h,92.11t/data=!3m7!1e1!3m5!1s9No6HrEqZ6NV2LyEh40MAw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D9No6HrEqZ6NV2LyEh40MAw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D214.41667%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3437362",
//        "lng": "-0.1980093",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 94
//    },
//    {
//        "referenceId": "STABS003",
//        "link": "https://www.google.com/maps/@51.3437362,-0.1980093,3a,90y,272.39h,92.11t/data=!3m7!1e1!3m5!1s9No6HrEqZ6NV2LyEh40MAw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D9No6HrEqZ6NV2LyEh40MAw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D214.41667%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3437362",
//        "lng": "-0.1980093",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 93
//    },
//    {
//        "referenceId": "STABS002",
//        "link": "https://www.google.com/maps/@51.3436227,-0.1971934,3a,90y,226.2h,80.22t/data=!3m6!1e1!3m4!1sDfo8Jb_s4nd4mnInDlPrXA!2e0!7i16384!8i8192",
//        "lat": "51.3436227",
//        "lng": "-0.1971934",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 92
//    },
//    {
//        "referenceId": "STBR006",
//        "link": "https://www.google.com/maps/@51.343505,-0.1988396,3a,90y,220.43h,98.68t/data=!3m7!1e1!3m5!1s0fgc200fu_bCKgvKExJUfA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D0fgc200fu_bCKgvKExJUfA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D266.61148%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.343505",
//        "lng": "-0.1988396",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 91
//    },
//    {
//        "referenceId": "STBLLCS002",
//        "link": "https://www.google.com/maps/@51.3435309,-0.198399,3a,75y,235.12h,89.73t/data=!3m7!1e1!3m5!1sHh7hG30ChjC0Su-NC4xsyg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DHh7hG30ChjC0Su-NC4xsyg%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D263.19354%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3435309",
//        "lng": "-0.198399",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 90
//    },
//    {
//        "referenceId": "STABS004",
//        "link": "https://www.google.com/maps/@51.343106,-0.1985734,3a,41.3y,35.94h,88.36t/data=!3m6!1e1!3m4!1swiDW3j8onvcjZYs2wNO4tw!2e0!7i16384!8i8192",
//        "lat": "51.343106",
//        "lng": "-0.1985734",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 89
//    },
//    {
//        "referenceId": "STBR003",
//        "link": "https://www.google.com/maps/@51.3411628,-0.2018965,3a,48.1y,206.88h,95.08t/data=!3m6!1e1!3m4!1sJ37-CZqKPo94MMuv25P57w!2e0!7i16384!8i8192",
//        "lat": "51.3411628",
//        "lng": "-0.2018965",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 88
//    },
//    {
//        "referenceId": "STBLLCS003",
//        "link": "https://www.google.com/maps/@51.3409311,-0.202371,3a,49.9y,21.16h,88.53t/data=!3m6!1e1!3m4!1sONykeEZjbSlFkbm6U2YhQg!2e0!7i16384!8i8192",
//        "lat": "51.3409311",
//        "lng": "-0.202371",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 87
//    },
//    {
//        "referenceId": "STBR008",
//        "link": "https://www.google.com/maps/@51.3444376,-0.2037243,3a,75y,312.58h,89.66t/data=!3m7!1e1!3m5!1s7oUi-DXxznmd5_nxsnjS5A!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D7oUi-DXxznmd5_nxsnjS5A%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D285.92334%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3444376",
//        "lng": "-0.2037243",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
//        "id": 86
//    },
//    {
//        "referenceId": "STSLZ001",
//        "link": "https://www.google.com/maps/@51.3444743,-0.2043883,3a,90y,294.21h,88.47t/data=!3m6!1e1!3m4!1syZJamJ2wECPGM73Hk9wVkQ!2e0!7i16384!8i8192",
//        "lat": "51.3444743",
//        "lng": "-0.2043883",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 85
//    },
//    {
//        "referenceId": "STBLLCS004",
//        "link": "https://www.google.com/maps/@51.3444234,-0.204353,3a,49.3y,226.6h,83.1t/data=!3m6!1e1!3m4!1sDmZJ0AST4z6Ord61G5lvPQ!2e0!7i13312!8i6656",
//        "lat": "51.3444234",
//        "lng": "-0.204353",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 84
//    },
//    {
//        "referenceId": "STBR009",
//        "link": "https://www.google.com/maps/@51.3475452,-0.204996,3a,88.1y,352.46h,96.72t/data=!3m7!1e1!3m5!1s7juW4OVo123hkoDeamNRjg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D7juW4OVo123hkoDeamNRjg%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D64.424774%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3475452",
//        "lng": "-0.204996",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 83
//    },
//    {
//        "referenceId": "STAn003",
//        "link": "https://www.google.com/maps/@51.3480534,-0.2062401,3a,88.4y,65.93h,104.05t/data=!3m7!1e1!3m5!1sb5Yfgg6xjFWb31v1HfFQAQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Db5Yfgg6xjFWb31v1HfFQAQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D28.28128%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3480534",
//        "lng": "-0.2062401",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 82
//    },
//    {
//        "referenceId": "STBLLCS005",
//        "link": "https://www.google.com/maps/@51.3475803,-0.205757,3a,75y,38.55h,88.84t/data=!3m6!1e1!3m4!1sMQjNQGgl07HHJPKAoEcOGQ!2e0!7i16384!8i8192",
//        "lat": "51.3475803",
//        "lng": "-0.205757",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 81
//    },
//    {
//        "referenceId": "STAn002",
//        "link": "https://www.google.com/maps/@51.3469293,-0.205661,3a,68.6y,313.84h,98.82t/data=!3m6!1e1!3m4!1s7GhSjaWb-Wu8KIpSYEF0qA!2e0!7i16384!8i8192",
//        "lat": "51.3469293",
//        "lng": "-0.205661",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 80
//    },
//    {
//        "referenceId": "STBR010",
//        "link": "https://www.google.com/maps/@51.3539837,-0.2094936,3a,90y,305.77h,97.45t/data=!3m6!1e1!3m4!1sALF0OkrFevQbnoMa-B1t4w!2e0!7i16384!8i8192",
//        "lat": "51.3539837",
//        "lng": "-0.2094936",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 79
//    },
//    {
//        "referenceId": "STBLLCS006",
//        "link": "https://www.google.com/maps/@51.3538498,-0.210271,3a,75y,59.86h,96.63t/data=!3m6!1e1!3m4!1svbCodMUKtWyC3-jJV4XvdQ!2e0!7i16384!8i8192",
//        "lat": "51.3538498",
//        "lng": "-0.210271",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 78
//    },
//    {
//        "referenceId": "STBR011",
//        "link": "https://www.google.com/maps/@51.355675,-0.2100698,3a,90y,203.29h,105.09t/data=!3m7!1e1!3m5!1sXSN-YPtv89Uv4wmnMG9QRA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DXSN-YPtv89Uv4wmnMG9QRA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D2.9093173%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.355675",
//        "lng": "-0.2100698",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 77
//    },
//    {
//        "referenceId": "STB008",
//        "link": "https://www.google.com/maps/@51.3554754,-0.2110831,3a,82.4y,344.8h,83.12t/data=!3m6!1e1!3m4!1sm6NgoTlIzbMy5U5N9TTW3Q!2e0!7i16384!8i8192",
//        "lat": "51.3554754",
//        "lng": "-0.2110831",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 75
//    },
//    {
//        "referenceId": "STAn004",
//        "link": "https://www.google.com/maps/@51.3548133,-0.211668,3a,48.9y,326.9h,89.53t/data=!3m6!1e1!3m4!1s1gZt3Z0W6Z__h6hUlBiU6A!2e0!7i16384!8i8192",
//        "lat": "51.3548133",
//        "lng": "-0.211668",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 74
//    },
//    {
//        "referenceId": "STABS005",
//        "link": "https://www.google.com/maps/@51.3552579,-0.2121319,3a,90y,336.53h,91.15t/data=!3m6!1e1!3m4!1sQ2lZz8IiK9XuzwSPNESnEA!2e0!7i16384!8i8192",
//        "lat": "51.3552579",
//        "lng": "-0.2121319",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 73
//    },
//    {
//        "referenceId": "STBR012",
//        "link": "https://www.google.com/maps/@51.3572016,-0.2119479,3a,90y,57.79h,96.12t/data=!3m7!1e1!3m5!1stxwvyDg_YCt1KRS8dPqybA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DtxwvyDg_YCt1KRS8dPqybA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D90.58428%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3572016",
//        "lng": "-0.2119479",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 72
//    },
//    {
//        "referenceId": "STABS006",
//        "link": "https://www.google.com/maps/@51.3574977,-0.2123718,3a,49.1y,327.44h,91.93t/data=!3m6!1e1!3m4!1skiC5h1Jm5o5ayk8En3HC3w!2e0!7i16384!8i8192",
//        "lat": "51.3574977",
//        "lng": "-0.2123718",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 71
//    },
//    {
//        "referenceId": "STBLLCS007",
//        "link": "https://www.google.com/maps/@51.3572309,-0.2120828,3a,75y,61.09h,93.21t/data=!3m6!1e1!3m4!1sxiK_hcrPvVBjVj6meSlalQ!2e0!7i16384!8i8192",
//        "lat": "51.3572309",
//        "lng": "-0.2120828",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 70
//    },
//    {
//        "referenceId": "STB009",
//        "link": "https://www.google.com/maps/@51.3571439,-0.2120455,3a,90y,126.34h,83.18t/data=!3m7!1e1!3m5!1sh55OZyinT7QRWK96n_vW8A!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Dh55OZyinT7QRWK96n_vW8A%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D124.800224%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3571439",
//        "lng": "-0.2120455",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 69
//    },
//    {
//        "referenceId": "STBR015",
//        "link": "https://www.google.com/maps/@51.3588004,-0.2125534,3a,75y,338.92h,96.54t/data=!3m7!1e1!3m5!1sy9POizwKP19AO21ueZKB8w!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Dy9POizwKP19AO21ueZKB8w%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D335.1889%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3588004",
//        "lng": "-0.2125534",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
//        "id": 68
//    },
//    {
//        "referenceId": "STB011",
//        "link": "https://www.google.com/maps/@51.3587822,-0.2131126,3a,48.8y,315.8h,92.76t/data=!3m6!1e1!3m4!1sJ0M9jjX20EHUw2kd_kwjGw!2e0!7i16384!8i8192",
//        "lat": "51.3587822",
//        "lng": "-0.2131126",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 67
//    },
//    {
//        "referenceId": "STB010",
//        "link": "https://www.google.com/maps/@51.3588486,-0.2130007,3a,75y,65.11h,87.19t/data=!3m6!1e1!3m4!1sFvhX43CBtz4Qi6fhBb3WfQ!2e0!7i16384!8i8192",
//        "lat": "51.3588486",
//        "lng": "-0.2130007",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 66
//    },
//    {
//        "referenceId": "STABS007",
//        "link": "https://www.google.com/maps/@51.3585343,-0.2140921,3a,49.1y,59.27h,96.33t/data=!3m6!1e1!3m4!1shuwmNxZTFW1ge3dQKM9iyQ!2e0!7i16384!8i8192",
//        "lat": "51.3585343",
//        "lng": "-0.2140921",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 65
//    },
//    {
//        "referenceId": "STDS010",
//        "link": "https://goo.gl/maps/JVamKU8nG4poS8he9",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 64
//    },
//    {
//        "referenceId": "STDS009",
//        "link": "https://goo.gl/maps/FVYN5cDcCXGNZYi3A",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 63
//    },
//    {
//        "referenceId": "STDS007",
//        "link": "https://goo.gl/maps/TztBTSaGS4vDMbDJ9",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 62
//    },
//    {
//        "referenceId": "STDS006",
//        "link": "https://goo.gl/maps/P7bHySArovbPBHUy9",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 61
//    },
//    {
//        "referenceId": "STBR017",
//        "link": "https://www.google.com/maps/@51.3598599,-0.2135868,3a,90y,283.19h,99.4t/data=!3m7!1e1!3m5!1s3fCHb5W1Dw-ZfDdOmuZeJw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D3fCHb5W1Dw-ZfDdOmuZeJw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D94.86983%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3598599",
//        "lng": "-0.2135868",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 60
//    },
//    {
//        "referenceId": "STBR016",
//        "link": "https://www.google.com/maps/@51.3587899,-0.2150158,3a,90y,270.87h,102.83t/data=!3m6!1e1!3m4!1s2Sf0_JA9KItY1XfXKb5l6A!2e0!7i16384!8i8192",
//        "lat": "51.3587899",
//        "lng": "-0.2150158",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 59
//    },
//    {
//        "referenceId": "STBLLCS008",
//        "link": "https://www.google.com/maps/@51.3582015,-0.2148484,3a,43y,1.4h,91.19t/data=!3m6!1e1!3m4!1s85zRpCjRfgPGCyABdVoIbg!2e0!7i16384!8i8192",
//        "lat": "51.3582015",
//        "lng": "-0.2148484",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 58
//    },
//    {
//        "referenceId": "STB012",
//        "link": "https://www.google.com/maps/@51.3582642,-0.2147453,3a,49.1y,22.37h,98.89t/data=!3m6!1e1!3m4!1scx5ksIAw74eP7jSIluVU0Q!2e0!7i16384!8i8192",
//        "lat": "51.3582642",
//        "lng": "-0.2147453",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 57
//    },
//    {
//        "referenceId": "STBR018",
//        "link": "https://www.google.com/maps/@51.3584936,-0.2170634,3a,57.3y,298.09h,92.94t/data=!3m6!1e1!3m4!1sPbT4e3HrPnJ1UO07Bkz8Ww!2e0!7i16384!8i8192",
//        "lat": "51.3584936",
//        "lng": "-0.2170634",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 56
//    },
//    {
//        "referenceId": "STBR014",
//        "link": "https://www.google.com/maps/@51.358783,-0.2166252,3a,62.4y,214.75h,93.29t/data=!3m7!1e1!3m5!1sRMnroq7gfeq_XtbmRyq9PA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DRMnroq7gfeq_XtbmRyq9PA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D143.75958%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.358783",
//        "lng": "-0.2166252",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 55
//    },
//    {
//        "referenceId": "STBLLCS009",
//        "link": "https://www.google.com/maps/@51.3576693,-0.2163554,3a,49.1y,316.28h,88.58t/data=!3m7!1e1!3m5!1sR-577nS-GfgFl7Wp3H1jTQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DR-577nS-GfgFl7Wp3H1jTQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D287.4467%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3576693",
//        "lng": "-0.2163554",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 54
//    },
//    {
//        "referenceId": "STABS009",
//        "link": "https://www.google.com/maps/place/Pizza+Express/@51.3575964,-0.2169138,3a,79.3y,320.42h,95.26t/data=!3m6!1e1!3m4!1sLZhG-yi5GJOyHjpj2aGMgw!2e0!7i16384!8i8192!4m13!1m7!3m6!1s0x0:0x713e6e3ad11adc0b!2zNTHCsDIxJzI2LjAiTiAwwrAxMic1OS4wIlc!3b1!8m2!3d51.357207!4d-0.2163909!3m4!1s0x487608091e311763:0xf5bda6e7ae2c3a59!8m2!3d51.3577133!4d-0.216954",
//        "lat": "51.3575964",
//        "lng": "-0.2169138",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 52
//    },
//    {
//        "referenceId": "STABS008",
//        "link": "https://www.google.com/maps/@51.3572994,-0.2162691,3a,85.7y,256.91h,86.36t/data=!3m6!1e1!3m4!1s7v4lGJ7MKajcob3tLWjtOg!2e0!7i16384!8i8192",
//        "lat": "51.3572994",
//        "lng": "-0.2162691",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 51
//    },
//    {
//        "referenceId": "STDS014",
//        "link": "https://goo.gl/maps/dgVYY7mgCfTqoZ6o6",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 50
//    },
//    {
//        "referenceId": "STDS013",
//        "link": "https://goo.gl/maps/V34gmm21sWvLFUYJ8",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 49
//    },
//    {
//        "referenceId": "STDS011",
//        "link": "https://goo.gl/maps/mjyubVjmjR6j9Uun6",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 48
//    },
//    {
//        "referenceId": "STBR013",
//        "link": "https://www.google.com/maps/@51.3579456,-0.2181688,3a,75y,271.63h,99.87t/data=!3m6!1e1!3m4!1se5SS8aueXyFVT8AnSvByyw!2e0!7i16384!8i8192",
//        "lat": "51.3579456",
//        "lng": "-0.2181688",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 47
//    },
//    {
//        "referenceId": "STB013",
//        "link": "https://www.google.com/maps/@51.3576812,-0.2181681,3a,75y,311.55h,90.69t/data=!3m7!1e1!3m5!1s2Dr6k1xcVoJDczZVEGME9g!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D2Dr6k1xcVoJDczZVEGME9g%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D60.826904%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3576812",
//        "lng": "-0.2181681",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 46
//    },
//    {
//        "referenceId": "STBR019",
//        "link": "https://www.google.com/maps/@51.3663727,-0.2327031,3a,85.2y,48.33h,101.44t/data=!3m7!1e1!3m5!1sVX1xCKcOV_7nuhEco3PH7g!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DVX1xCKcOV_7nuhEco3PH7g%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D104.3928%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3663727",
//        "lng": "-0.2327031",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 45
//    },
//    {
//        "referenceId": "STBLLCS010",
//        "link": "https://www.google.com/maps/@51.3665526,-0.2328393,3a,75y,143.2h,98.61t/data=!3m7!1e1!3m5!1se6YisoO_7gF0dWtjUAm9Ig!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3De6YisoO_7gF0dWtjUAm9Ig%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D160.89755%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3665526",
//        "lng": "-0.2328393",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 44
//    },
//    {
//        "referenceId": "STBR020",
//        "link": "https://www.google.com/maps/@51.3670778,-0.2311395,3a,43.4y,110.16h,92.3t/data=!3m6!1e1!3m4!1scpVtkQUqSu1NC1Dw6Yh0Ww!2e0!7i16384!8i8192",
//        "lat": "51.3670778",
//        "lng": "-0.2311395",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 43
//    },
//    {
//        "referenceId": "STBLLCS011",
//        "link": "https://www.google.com/maps/@51.3673482,-0.2320195,3a,41.4y,74.66h,84.96t/data=!3m6!1e1!3m4!1sUgTLGzwoOxwS0wvrj7un4Q!2e0!7i16384!8i8192",
//        "lat": "51.3673482",
//        "lng": "-0.2320195",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
//        "id": 42
//    },
//    {
//        "referenceId": "STBR021",
//        "link": "https://www.google.com/maps/@51.3678144,-0.2311687,3a,90y,161.72h,91.48t/data=!3m7!1e1!3m5!1sSQydebBAeLY3YA_F-fS_6g!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DSQydebBAeLY3YA_F-fS_6g%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D227.37418%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3678144",
//        "lng": "-0.2311687",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 41
//    },
//    {
//        "referenceId": "STAn005",
//        "link": "https://www.google.com/maps/@51.3683842,-0.23092,3a,75y,162.83h,102.9t/data=!3m6!1e1!3m4!1sS6bev1C8GmFP2Za5v8GQJw!2e0!7i13312!8i6656",
//        "lat": "51.3683842",
//        "lng": "-0.23092",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 40
//    },
//    {
//        "referenceId": "STB014",
//        "link": "https://www.google.com/maps/@51.3678614,-0.2314289,3a,71.7y,96.6h,86.4t/data=!3m6!1e1!3m4!1sArJ_jGiGhEekUd7nqjyBtA!2e0!7i13312!8i6656",
//        "lat": "51.3678614",
//        "lng": "-0.2314289",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 39
//    },
//    {
//        "referenceId": "STBR022",
//        "link": "https://www.google.com/maps/@51.3687707,-0.2291105,3a,42.8y,340.55h,92.66t/data=!3m7!1e1!3m5!1sUUkcB7PI77kc2u1VXHetAA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DUUkcB7PI77kc2u1VXHetAA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D339.85492%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3687707",
//        "lng": "-0.2291105",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 38
//    },
//    {
//        "referenceId": "STBLLCS012",
//        "link": "https://www.google.com/maps/@51.3692221,-0.2298172,3a,75y,52.27h,97.64t/data=!3m7!1e1!3m5!1saXS5b4oOy6AH4UjLP6UKow!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DaXS5b4oOy6AH4UjLP6UKow%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D19.29797%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3692221",
//        "lng": "-0.2298172",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 37
//    },
//    {
//        "referenceId": "STBR023",
//        "link": "https://www.google.com/maps/@51.3708093,-0.2277111,3a,75y,82.99h,86.82t/data=!3m7!1e1!3m5!1sDQ0E52XWlz2XShTnHJ0_gw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DDQ0E52XWlz2XShTnHJ0_gw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D134.3698%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3708093",
//        "lng": "-0.2277111",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 36
//    },
//    {
//        "referenceId": "STB016",
//        "link": "https://www.google.com/maps/@51.3710361,-0.2280361,3a,55y,7.38h,93.4t/data=!3m7!1e1!3m5!1scgIAv--Ams12pJeAZufb4Q!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DcgIAv--Ams12pJeAZufb4Q%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D111.69474%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3710361",
//        "lng": "-0.2280361",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 35
//    },
//    {
//        "referenceId": "STABS010",
//        "link": "https://www.google.com/maps/@51.3703368,-0.2288409,3a,75y,23.7h,86.57t/data=!3m6!1e1!3m4!1stie85KK3UrntDHs6M_UKog!2e0!7i16384!8i8192",
//        "lat": "51.3703368",
//        "lng": "-0.2288409",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 34
//    },
//    {
//        "referenceId": "STB015",
//        "link": "https://www.google.com/maps/@51.3710361,-0.2280361,3a,63.6y,118.98h,96.94t/data=!3m7!1e1!3m5!1scgIAv--Ams12pJeAZufb4Q!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DcgIAv--Ams12pJeAZufb4Q%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D111.69474%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3710361",
//        "lng": "-0.2280361",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 33
//    },
//    {
//        "referenceId": "STDS016",
//        "link": "https://goo.gl/maps/XhLnVUtAJTCkCMRz8",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 32
//    },
//    {
//        "referenceId": "STDS015",
//        "link": "https://goo.gl/maps/UMzunqYrWwmQZFMX9",
//        "lat": "51.50846347027058",
//        "lng": "0.20084608382851304",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 31
//    },
//    {
//        "referenceId": "STBR024",
//        "link": "https://www.google.com/maps/@51.3717811,-0.2271762,3a,90y,276h,103.63t/data=!3m7!1e1!3m5!1sS1EyMZcprV3Ov46vcgElFQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DS1EyMZcprV3Ov46vcgElFQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D229.07642%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3717811",
//        "lng": "-0.2271762",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 30
//    },
//    {
//        "referenceId": "STBR025",
//        "link": "https://www.google.com/maps/@51.3722104,-0.2274799,3a,75y,57.63h,92.83t/data=!3m7!1e1!3m5!1sXnhGqnyyGKv9u-DdSe_6vA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DXnhGqnyyGKv9u-DdSe_6vA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D76.11121%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3722104",
//        "lng": "-0.2274799",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 29
//    },
//    {
//        "referenceId": "STB017",
//        "link": "https://www.google.com/maps/@51.3713843,-0.228533,3a,90y,79.1h,102.41t/data=!3m6!1e1!3m4!1sF36XEaDxM8fDn1_RM6oAvg!2e0!7i16384!8i8192",
//        "lat": "51.3713843",
//        "lng": "-0.228533",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
//        "id": 28
//    },
//    {
//        "referenceId": "STABS011",
//        "link": "https://www.google.com/maps/@51.3716905,-0.2290473,3a,75y,100.72h,93.3t/data=!3m6!1e1!3m4!1sstvHbBvTse8F9bxpDOsl6g!2e0!7i16384!8i8192",
//        "lat": "51.3716905",
//        "lng": "-0.2290473",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 27
//    },
//    {
//        "referenceId": "STBR026",
//        "link": "https://www.google.com/maps/@51.3730355,-0.2308738,3a,90y,128.56h,96.52t/data=!3m6!1e1!3m4!1s8PsM_Nc-4QbGk9mWpSHIEw!2e0!7i16384!8i8192",
//        "lat": "51.3730355",
//        "lng": "-0.2308738",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 26
//    },
//    {
//        "referenceId": "STBLLCS013",
//        "link": "https://www.google.com/maps/@51.3727026,-0.2312169,3a,75y,38.13h,100.42t/data=!3m7!1e1!3m5!1sTjORzfX9AfjCFZ6ct4TGbQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DTjORzfX9AfjCFZ6ct4TGbQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D306.97772%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3727026",
//        "lng": "-0.2312169",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 25
//    },
//    {
//        "referenceId": "STAn006",
//        "link": "https://www.google.com/maps/@51.3729781,-0.2317934,3a,90y,349.96h,100.7t/data=!3m6!1e1!3m4!1s0zA_zA8QXy_m0jj9JZgT6w!2e0!7i16384!8i8192",
//        "lat": "51.3729781",
//        "lng": "-0.2317934",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 24
//    },
//    {
//        "referenceId": "STBR027",
//        "link": "https://www.google.com/maps/@51.3748829,-0.2329879,3a,90y,324.94h,95.07t/data=!3m7!1e1!3m5!1s33EJuBM41vOd85JrxAy4IA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D33EJuBM41vOd85JrxAy4IA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D93.01325%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3748829",
//        "lng": "-0.2329879",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 23
//    },
//    {
//        "referenceId": "STBLLCS014",
//        "link": "https://www.google.com/maps/@51.3743614,-0.234001,3a,75y,70.53h,98.55t/data=!3m7!1e1!3m5!1spleBlBJ0lz552xbz73Rtow!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DpleBlBJ0lz552xbz73Rtow%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D45.718773%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3743614",
//        "lng": "-0.234001",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 22
//    },
//    {
//        "referenceId": "STAn007",
//        "link": "https://www.google.com/maps/@51.3743215,-0.2338944,3a,75y,117.16h,99.98t/data=!3m6!1e1!3m4!1skwPfdiYrWjEqBSDL9vllDg!2e0!7i16384!8i8192",
//        "lat": "51.3743215",
//        "lng": "-0.2338944",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 21
//    },
//    {
//        "referenceId": "STBR028",
//        "link": "https://www.google.com/maps/@51.3761189,-0.2354501,3a,74y,256.02h,91.73t/data=!3m6!1e1!3m4!1sWtiu2HYdswO88yXEjb-AjQ!2e0!7i16384!8i8192",
//        "lat": "51.3761189",
//        "lng": "-0.2354501",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 20
//    },
//    {
//        "referenceId": "STBLLCS015",
//        "link": "https://www.google.com/maps/@51.3758127,-0.2358103,3a,75y,45.01h,86.73t/data=!3m6!1e1!3m4!1sWc_aJI5V1_HIKZpPyEB7Sw!2e0!7i16384!8i8192",
//        "lat": "51.3758127",
//        "lng": "-0.2358103",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 19
//    },
//    {
//        "referenceId": "STAn008",
//        "link": "https://www.google.com/maps/@51.3762694,-0.2363988,3a,72.9y,123.2h,95.67t/data=!3m6!1e1!3m4!1seYQSSmaaxik0EwQumqMxCA!2e0!7i16384!8i8192",
//        "lat": "51.3762694",
//        "lng": "-0.2363988",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 18
//    },
//    {
//        "referenceId": "STBR029",
//        "link": "https://www.google.com/maps/@51.3771618,-0.2362956,3a,75y,63.37h,83.12t/data=!3m6!1e1!3m4!1sNH4MQidyT8bdqVy-ffWGtQ!2e0!7i16384!8i8192",
//        "lat": "51.3771618",
//        "lng": "-0.2362956",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 17
//    },
//    {
//        "referenceId": "STB018",
//        "link": "https://www.google.com/maps/@51.3765751,-0.2368989,3a,75y,64.08h,80.96t/data=!3m6!1e1!3m4!1sscoy2eEUHD6i6Hrs0i0Axg!2e0!7i16384!8i8192",
//        "lat": "51.3765751",
//        "lng": "-0.2368989",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 16
//    },
//    {
//        "referenceId": "STAn009",
//        "link": "https://www.google.com/maps/@51.3765812,-0.2368939,3a,69.4y,5.9h,98.18t/data=!3m6!1e1!3m4!1sscoy2eEUHD6i6Hrs0i0Axg!2e0!7i16384!8i8192",
//        "lat": "51.3765812",
//        "lng": "-0.2368939",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/red-dot.png",
//        "id": 15
//    },
//    {
//        "referenceId": "STBR030",
//        "link": "https://www.google.com/maps/@51.3778469,-0.2381632,3a,90y,307.76h,92.17t/data=!3m6!1e1!3m4!1suAmDW3mFbeFCPGjXejlYWQ!2e0!7i16384!8i8192",
//        "lat": "51.3778469",
//        "lng": "-0.2381632",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 14
//    },
//    {
//        "referenceId": "STB019",
//        "link": "https://www.google.com/maps/@51.3772591,-0.2388843,3a,75y,36.91h,86.41t/data=!3m7!1e1!3m5!1sa1hpFBMnM-_rw7mAgZexxQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Da1hpFBMnM-_rw7mAgZexxQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D2.706126%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3772591",
//        "lng": "-0.2388843",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 13
//    },
//    {
//        "referenceId": "STAn010",
//        "link": "https://www.google.com/maps/@51.3772591,-0.2388843,3a,88.2y,347.24h,102.11t/data=!3m7!1e1!3m5!1sa1hpFBMnM-_rw7mAgZexxQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Da1hpFBMnM-_rw7mAgZexxQ%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D2.706126%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3772591",
//        "lng": "-0.2388843",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 12
//    },
//    {
//        "referenceId": "STBR031",
//        "link": "https://www.google.com/maps/@51.3786633,-0.238905,3a,90y,355.67h,94.6t/data=!3m7!1e1!3m5!1sHNELCETuCdylXx70VM3dYw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DHNELCETuCdylXx70VM3dYw%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D40.83387%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3786633",
//        "lng": "-0.238905",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 11
//    },
//    {
//        "referenceId": "STBLLCS016",
//        "link": "https://www.google.com/maps/@51.3777458,-0.2398087,3a,75y,13.7h,85.13t/data=!3m6!1e1!3m4!1s3PJCC9HbWlqr77KQK-SGKw!2e0!7i16384!8i8192",
//        "lat": "51.3777458",
//        "lng": "-0.2398087",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 10
//    },
//    {
//        "referenceId": "STBR032",
//        "link": "https://www.google.com/maps/@51.3783751,-0.2407096,3a,90y,314.71h,94.16t/data=!3m7!1e1!3m5!1s33Kd-Hkl1IqgtBFYPJqHkA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3D33Kd-Hkl1IqgtBFYPJqHkA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D70.81739%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3783751",
//        "lng": "-0.2407096",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 9
//    },
//    {
//        "referenceId": "STBLLCS017",
//        "link": "https://www.google.com/maps/@51.378231,-0.2408264,3a,75y,46.41h,88.43t/data=!3m6!1e1!3m4!1slgHr5C4DChQ_EjxH3d7A1A!2e0!7i16384!8i8192",
//        "lat": "51.378231",
//        "lng": "-0.2408264",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 8
//    },
//    {
//        "referenceId": "STAn011",
//        "link": "https://www.google.com/maps/@51.3782209,-0.2410416,3a,80.8y,12.29h,99.39t/data=!3m6!1e1!3m4!1sUyb4zxgeNFTEShCkKqNiKA!2e0!7i16384!8i8192",
//        "lat": "51.3782209",
//        "lng": "-0.2410416",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 7
//    },
//    {
//        "referenceId": "STBR033",
//        "link": "https://www.google.com/maps/@51.3793101,-0.2411747,3a,75y,276.46h,90.95t/data=!3m7!1e1!3m5!1sl_JQtSUxFhLotDSTZ7diZA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3Dl_JQtSUxFhLotDSTZ7diZA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D208.83781%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.3793101",
//        "lng": "-0.2411747",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 6
//    },
//    {
//        "referenceId": "STBLLCS018",
//        "link": "https://www.google.com/maps/@51.3786835,-0.2417562,3a,79.8y,40.09h,86.7t/data=!3m6!1e1!3m4!1sWWe8Bih75mVnekUT888KlA!2e0!7i16384!8i8192",
//        "lat": "51.3786835",
//        "lng": "-0.2417562",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 5
//    },
//    {
//        "referenceId": "STBR034",
//        "link": "https://www.google.com/maps/@51.380621,-0.2431748,3a,90y,141.79h,100.11t/data=!3m7!1e1!3m5!1sG6CKGKjEVKZIeFTty9UZqA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fpanoid%3DG6CKGKjEVKZIeFTty9UZqA%26cb_client%3Dmaps_sv.tactile.gps%26w%3D203%26h%3D100%26yaw%3D114.4917%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192",
//        "lat": "51.380621",
//        "lng": "-0.2431748",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/blue-dot.png",
//        "id": 4
//    },
//    {
//        "referenceId": "STB020",
//        "link": "https://www.google.com/maps/@51.3801994,-0.2440908,3a,63.2y,21.66h,85.39t/data=!3m6!1e1!3m4!1sN2jX5mwkf5_g962lqnTGpg!2e0!7i16384!8i8192",
//        "lat": "51.3801994",
//        "lng": "-0.2440908",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 3
//    },
//    {
//        "referenceId": "STAn012",
//        "link": "https://www.google.com/maps/@51.380676,-0.2449047,3a,90y,89.61h,122.58t/data=!3m6!1e1!3m4!1spxv4FGWMVWF3IVo45C5BsA!2e0!7i16384!8i8192",
//        "lat": "51.380676",
//        "lng": "-0.2449047",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 2
//    },
//    {
//        "referenceId": "STABS012",
//        "link": "https://www.google.com/maps/@51.3797642,-0.2437586,3a,88.3y,241.5h,106.74t/data=!3m6!1e1!3m4!1svf9nHsZWQFpQ75I-U0tQvg!2e0!7i16384!8i8192",
//        "lat": "51.3797642",
//        "lng": "-0.2437586",
//        "icon": "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
//        "id": 1
//    }
//]
