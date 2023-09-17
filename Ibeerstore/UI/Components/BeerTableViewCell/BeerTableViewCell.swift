//
//  BeerTableViewCell.swift
//  Ibeerstore
//
//  Created by Filipe Ferreira on 10/09/23.
//

import UIKit

class BeerTableViewCell: UITableViewCell {


    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!
    
    func createShadow()
    {
        beerImageView.clipsToBounds = true;
        /*
        bodyView.layer.masksToBounds = false;
        bodyView.layer.shadowOffset = CGSize(width: -1, height: 1);
        bodyView.layer.shadowRadius = 1;
        bodyView.layer.shadowOpacity = 0.5;*/
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
