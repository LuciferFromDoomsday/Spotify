//
//  ProfileViewController.swift
//  Spotify
//
//  Created by admin on 2/19/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self ,forCellReuseIdentifier: "cell" )
        return tableView
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchUserProfile()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    private func fetchUserProfile(){
        APICaller.shared.getCurrentUserProfile{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with : model)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetprofile()
                }
            }
           
            
        }
       
    }
    
    private func updateUI(with model: UserProfile){
        tableView.isHidden = false
        print("salam")
        // configure table models
        models.append("Full Name : \(model.display_name)" )
        models.append("Country : \(model.country)" )
        models.append("Plan : \(model.product)" )
        models.append("User Id : \(model.id)" )
        print(models)
        createTableHeader(with: model.images.first?.url)
    tableView.reloadData()
        
    }
    
    private func createTableHeader(with string: String?){
        
        guard let urlString = string , let url = URL(string: urlString) else {
            return
        }
        
        let headerView = UIView(frame:  CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height / 2
        
        let imageView : UIImageView = UIImageView(frame:  CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        tableView.tableHeaderView = headerView
        
        
        
    }
    
    private func failedToGetprofile(){
        let label  = UILabel(frame: .zero)
        label.text = "Failed to load ..."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        
        label.center = view.center
    }
    
    // MARK - TableView
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
    




