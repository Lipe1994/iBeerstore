//
//  ViewController.swift
//  Ibeerstore
//
//  Created by Filipe Ferreira on 10/09/23.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!;
    private var pullControl = UIRefreshControl();
    
    var beers: [BeerHttpModel] = [];
    var loading: Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let uiNib = UINib(nibName: "BeerTableViewCell", bundle: nil);
        tableView.register(uiNib, forCellReuseIdentifier: "BeerTableViewCell")
        

        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
        loadBeers();
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        loadBeers();
    }
    
    func setupRefreshControl()
    {
        pullControl.attributedTitle = NSAttributedString("Pull to refresh");
        pullControl.addTarget(self, action: #selector(loadBeers), for: .valueChanged)
        pullControl.tintColor = .orange;
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = pullControl;
        }else{
            tableView.addSubview(pullControl);
        }
    }
    
    @objc func loadBeers()
    {
        DispatchQueue.main.async {
            self.pullControl.endRefreshing();
            self.beers = [];
            self.loading = true;
            self.tableView.reloadData();
        }
        
        BeerstoreHttpService().getBeers{ [self] beers in
            self.beers = beers;
            self.loading = false;
            DispatchQueue.main.async {
                self.tableView.reloadData();
                self.view.hideToastActivity();
            }
        };
    }
    
    @objc func goToAddBeer()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "AddBeerViewController", bundle:nil);
        let addBeerViewController = storyBoard.instantiateViewController(withIdentifier: "AddBeerViewController") as! AddBeerViewController;
        addBeerViewController.modalPresentationStyle = .fullScreen;
        
        self.present(addBeerViewController, animated:true, completion:nil)
    }
    
    @objc func goToUpdateBeer(row: Int)
    {
        let beer = beers[row];
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "AddBeerViewController", bundle:nil);
        let addBeerViewController = storyBoard.instantiateViewController(withIdentifier: "AddBeerViewController") as! AddBeerViewController;
        
        addBeerViewController.modalPresentationStyle = .fullScreen;
        addBeerViewController.beer = beer;
        
        self.present(addBeerViewController, animated:true, completion:nil)
    }
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        goToUpdateBeer(row: indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") {
            action, view, boolAction in
            boolAction(true);
            
            let deleteConfirmation = UIAlertController(title: nil, message: "Você deseja, realmente excluir \(self.beers[indexPath.row].name)", preferredStyle: .alert);
            
            deleteConfirmation.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: { action in
                
                
                DispatchQueue.main.async {
                    self.view.makeToastActivity(.center);
                }
                BeerstoreHttpService().deleteBeers(self.beers[indexPath.row].id!, completion: {
                    self.loadBeers();
                });
                
            }));
            
            deleteConfirmation.addAction(UIAlertAction(title: "Cancelar", style: .cancel));
            
            self.present(deleteConfirmation ,animated: true);
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction]);
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderTableView", owner: self, options: nil)?.first as? HeaderTableView;
        
        headerView?.addNewBeerButton.addTarget(self, action: #selector(goToAddBeer) , for: .touchUpInside);
        
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80;
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading{
            return 1;
        }
        return beers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if loading{
            let cellLoading = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for:  indexPath) as! LoadingTableViewCell;
            cellLoading.activityIndicator.startAnimating();
            return cellLoading;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as! BeerTableViewCell;
        
        cell.nameLabel.text = beers[indexPath.row].name;
        cell.typeLabel.text = beers[indexPath.row].type;
        cell.volumeLabel.text = String(beers[indexPath.row].volume);

        cell.createShadow();
        
        return cell;
    }
    
    
}

