//
//  DetailPresenter.swift
//  mvp_testApp
//
//  Created by Serhii  on 17/09/2022.
//

import Foundation

protocol FolderViewProtocol: AnyObject {
    func reloadTable()
}

protocol FolderPresenterProtocol: AnyObject {
    func getNumberOfRow() -> Int
    func getTitle(for index: IndexPath) -> String
    func getText(for index: IndexPath) -> String
    func getFolderTitle() -> String
    func showNote(for index: IndexPath)
    func showSearchResults(for text: String)
}

class FolderPresenter: FolderPresenterProtocol {
    weak var view: FolderViewProtocol?
    var router: RouterProtocol?
    private let folder: NotesFolder?
    private var filteredFolder: NotesFolder?

    required init(view: FolderViewProtocol, folder: NotesFolder?, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.folder = folder
        self.filteredFolder = folder
    }

    func getNumberOfRow() -> Int {
        filteredFolder?.countNotes ?? 0
    }

    func getTitle(for index: IndexPath) -> String {
        return filteredFolder?.folder[index.row].title ?? ""
    }

    func getText(for index: IndexPath) -> String {
        return filteredFolder?.folder[index.row].text ?? ""
    }

    func getFolderTitle() -> String {
        return filteredFolder?.title ?? ""
    }

    func showNote(for index: IndexPath) {
        let note = filteredFolder?.folder[index.row]
        router?.showNote(note: note)
    }

    func showSearchResults(for text: String) {
        filteredFolder?.folder = [Note]()
        if let folder = folder {
            if text == "" {
                filteredFolder?.folder = folder.folder
            } else {
                for item in folder.folder {
                    if item.title.lowercased().contains(text.lowercased()) {
                        filteredFolder?.folder.append(item)
                    }
                }
            }
        }
        self.view?.reloadTable()
    }
}
