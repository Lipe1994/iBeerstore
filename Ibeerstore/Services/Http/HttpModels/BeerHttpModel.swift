//
//  BeerHttpModel.swift
//  Ibeerstore
//
//  Created by Filipe Ferreira on 10/09/23.
//

import Foundation

struct BeerHttpModel: Codable{
    let id: Int?
    let name: String
    let type: String
    let volume: Int
    
    static func toDict(id: Int?, name: String, volume: Int, type: Int) -> [String:Any?]
    {
        return [
            "id": id,
            "name": name,
            "volume": volume,
            "type": type,
        ];
    }
}
