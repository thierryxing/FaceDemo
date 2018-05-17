//
//  ChooseImageViewController.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/9.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import UIKit

class ChooseImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "project_reuseIdentifier")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.imageView?.image = UIImage(named: "demo\(indexPath.row+1).jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = HandleImageViewController()
        controller.portraitImage = UIImage(named: "demo\(indexPath.row+1).jpg")
        navigationController?.pushViewController(controller, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

