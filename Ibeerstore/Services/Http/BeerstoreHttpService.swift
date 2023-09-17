//
//  BeerstoreHttpService.swift
//  Ibeerstore
//
//  Created by Filipe Ferreira on 10/09/23.
//

import Foundation

class BeerstoreHttpService: HttpService
{
    func getBeers(completion: @escaping([BeerHttpModel])->()){
        let task = URLSession.shared.dataTask(with: baseUrl!.appending(path: "beers")) {
            data, response, error in
            
            print("response: \(String(describing: response))")
            print("error: \(String(describing: error))")
            
            do{
                let res = try JSONDecoder().decode([BeerHttpModel].self, from: data!);
                completion(res);
            }catch let error{
                print(error);
                //throw exception("Erro \(error)");
            }
        }
        
        task.resume();
    }
    
    func deleteBeers(_ id:Int, completion: @escaping()->()){
        let url = baseUrl!.appending(path: "beers/\(String(id))");
        var req = URLRequest(url: url);
        req.httpMethod = "DELETE";
        
        let task = URLSession.shared.dataTask(with: req) {
            data, response, error in
            
            print("response: \(String(describing: response))")
            print("error: \(String(describing: error))")
            completion();
        }
        
        task.resume();
    }
    
    func createBeer(_ beer: [String:Any?], completion: @escaping()->()){
        let url = baseUrl!.appending(path: "beers");
        var req = URLRequest(url: url);
        req.httpMethod = "POST";
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        do{
            req.httpBody = try JSONSerialization.data(withJSONObject:beer, options: .prettyPrinted);
            
        }catch{
            print("Error in createBeer");
        }
        
        
        let task = URLSession.shared.dataTask(with: req) {
            data, response, error in
            
            print("response: \(String(describing: response))")
            print("error: \(String(describing: error))")
            completion();
        }
        
        task.resume();
    }
    
    func updateBeer(_ id: Int, _ beer: [String:Any?], completion: @escaping()->()){
        let url = baseUrl!.appending(path: "beers/\(id)");
        var req = URLRequest(url: url);
        req.httpMethod = "PUT";
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        do{
            req.httpBody = try JSONSerialization.data(withJSONObject:beer, options: .prettyPrinted);
            
        }catch{
            print("Error in createBeer");
        }
        
        
        let task = URLSession.shared.dataTask(with: req) {
            data, response, error in
            
            print("response: \(String(describing: response))")
            print("error: \(String(describing: error))")
            completion();
        }
        
        task.resume();
    }

}
