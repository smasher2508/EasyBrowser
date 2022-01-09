//
//  ListViewController.swift
//  EasyBrowser
//
//  Created by Barkha Maheshwari on 30/05/21.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let websites = ["apple.com", "hackingwithswift.com", "stackoverflow.com", "github.com", "slack.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "Websites List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") else {
            return UITableViewCell(frame: .zero)
        }
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
        vc.websiteSubURL = websites[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
