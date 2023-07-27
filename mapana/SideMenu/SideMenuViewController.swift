//
//  SideMenuViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet var sideMenuTableView: UITableView!

    var delegate: SideMenuViewControllerDelegate?

    var defaultHighlightedCell: Int = 0

    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "routes")!, title: "Route"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.separatorStyle = .none

        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    @IBAction func btnSignOutClicked(_ sender: UIButton) {
        var logOutAlert = UIAlertController(title: "Lattice Mapana", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

        logOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            print("Handle Ok logic here")
            guard let self = self else { return }
            self.makeUserLogout()
        }))

        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
            self.delegate?.selectedCell(0)
          }))

        present(logOutAlert, animated: true, completion: nil)
    }
    
    func makeUserLogout() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first
            if window != nil {
                /// Remove Defaults
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                /// Change vc
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                //let navController = UINavigationController(rootViewController: loginVC!)
                window!.rootViewController = nil
                window!.rootViewController = loginVC
                window!.makeKeyAndVisible()
                UIView.transition(with: window!, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.delegate?.selectedCell(0)
    }
    
}



// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
       //let myCustomSelectionColorView = UIView()
       // myCustomSelectionColorView.backgroundColor = UIColor(red: 237, green: 238, blue: 255, alpha: 1.0)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
    }
}
