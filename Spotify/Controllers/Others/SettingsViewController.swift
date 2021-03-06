//
//  SettingsViewController.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import UIKit

class SettingsViewController: UIViewController  , UITableViewDelegate ,UITableViewDataSource{

    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        title = "Settings"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func configureModels(){
        sections.append(Section(Title: "Profile", options: [Option(title: "View Your Profile", handler: {[weak self] in
            DispatchQueue.main.async {
              
                self?.viewProfile()
            }
          
            
        })]))
        sections.append(Section(Title: "Account", options: [Option(title: "Sign Out", handler: {[weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
          
            
        })]))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func signOutTapped(){
     
    }
    private func viewProfile(){
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        model.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.Title
    }

}
