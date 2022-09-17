//
//  ViewController.swift
//  mvp_testApp
//
//  Created by User on 15.09.2022.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {

    // MARK: - Private properties

    var presenter: MainPresenterProtocol?

    // MARK: - Outlets

    private lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search"
        return search
    }()

    private lazy var notesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups

    private func setupNavBar() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(buttonTapped))
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.searchController = searchController
    }

    private func setupHierarchy() {
        view.addSubview(notesTable)
    }

    private func setupLayout() {
        notesTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }

    @objc func buttonTapped() {
        // Any action
    }

}

extension MenuViewController {
    func setNoteCell(notes: Note) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = notes.title
        cell.detailTextLabel?.text = notes.subtitle
        cell.imageView?.image = UIImage(systemName: "folder")
        cell.tintColor = .systemYellow
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

    // MARK: - Extensions

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter?.getNumberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter?.getNumberOfRow(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = self.presenter?.notes[indexPath.section][indexPath.row] else { return UITableViewCell() }
        return setNoteCell(notes: note)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ICloud"
        case 1:
            return "Private notes"
        case 2:
            return "Other notes"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.textLabel?.frame = CGRect(x: headerView.bounds.origin.x + 20,
                                             y: headerView.bounds.origin.y,
                                             width: 100,
                                             height: headerView.bounds.height)
        headerView.textLabel?.textColor = .black
        if section == 0 {
            headerView.textLabel?.text = headerView.textLabel?.text?.capitalizeSecondLetter()
        } else {
            headerView.textLabel?.text = headerView.textLabel?.text?.capitalizeFirstLetter()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let note = self.presenter?.notes[indexPath.section][indexPath.row]
        presenter?.showDetail(data: note)
    }
}

