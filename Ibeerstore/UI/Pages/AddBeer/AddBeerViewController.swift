//
//  AddBeerViewController.swift
//  Ibeerstore
//
//  Created by Filipe Ferreira on 11/09/23.
//

import UIKit
import Toast_Swift

struct BeerType{
    var text: String;
    var value: Int;
    
    init(text: String, value: Int)
    {
        self.text = text;
        self.value = value;
    }
}

class AddBeerViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var volumeLabel: UITextField!
    @IBOutlet weak var typePickerView: UIPickerView!
    var type: Int = 0;
    var id:Int? = nil;
    var beer:BeerHttpModel?;
    
    @IBOutlet weak var saveButton: UIButton!
    var typeBeers: [BeerType] = [
        BeerType(text: "LARGER", value: 0),
        BeerType(text: "PILSEN", value: 1),
        BeerType(text: "IPA", value: 2)
    ];
    
    func loadForm(){
        
        guard let beer = self.beer else{
            titleLabel.text = "Adicionar cerveja";
            return;
        }
        
        titleLabel.text = "Atualizando cerveja";
        
        id = beer.id;
        nameLabel.text = beer.name;
        volumeLabel.text = String(beer.volume);
        
        type = typeBeers.first{ beerType in
            beerType.text == beer.type;
        }?.value ?? 0;
        
        let index = typeBeers.firstIndex{ beerType in
            beerType.text == beer.type;
        } ?? 0;
        
        typePickerView.selectRow(index, inComponent: 0, animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        
        typePickerView.delegate = self;
        typePickerView.dataSource = self;
        loadForm();
    }
    
    
    @IBAction func calcel(_ sender: Any) {
        self.view.hideAllToasts();
        self.dismiss(animated: true);
    }
    
    @IBAction func save(_ sender: Any) {
        let name = nameLabel.text ?? "";
        let volume = volumeLabel.text ?? "";
        
        if name.isEmpty || volume.isEmpty{
            self.view.makeToast("Você deve inserir 'Nome' e 'volume'");
            return;
        }
        
        if Int(volume) == nil {
            self.view.makeToast("Volume deve ser um valor numerico.");
            return;
        }
        
        self.view.makeToastActivity(.center);
        
        let beer = BeerHttpModel.toDict(
            id: id,
            name: name,
            volume: Int(volume)!,
            type: self.type
        );
        
        if id == nil {
            BeerstoreHttpService().createBeer(beer, completion: {
                
                DispatchQueue.main.async {
                    self.view.hideAllToasts();
                    self.view.hideToastActivity();
                    self.dismiss(animated: true);
                }
            });
        }else{
            BeerstoreHttpService().updateBeer(id!, beer, completion: {
                
                DispatchQueue.main.async {
                    self.view.hideAllToasts();
                    self.view.hideToastActivity();
                    self.dismiss(animated: true);
                }
            });
        }

    }
}

extension AddBeerViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeBeers.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeBeers[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.type = row;
    }
}
