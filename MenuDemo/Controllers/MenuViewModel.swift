//
//  MenuViewModel.swift
//  MenuDemo
//

import Foundation

class MenuViewModel {
    var rows: [MenuViewModel.Row] = []
    var delegate: MenuViewProtocol?
    
    private var isRowDisable: Bool = true
    var isMenuOpen: Bool  = false
    
    init(delegate: MenuViewProtocol) {
        self.delegate = delegate
        createMenu()
    }
    
    func createMenu() {
        rows.removeAll()
        
        rows.append(.menu(title: MenuView.airplaneMode,
                          imageName: "airplane"))
        
        rows.append(.menu(title: MenuView.cellularData,
                          imageName: "network"))
        
        rows.append(.menu(title: MenuView.wifi,
                          imageName: "wifi"))
        
        rows.append(.menu(title: MenuView.book,
                          imageName: "book.fill"))
        if isMenuOpen {
            rows.append(.menu(title: MenuView.airDrop,
                              imageName: "airplayaudio"))
            
            rows.append(.menu(title: MenuView.personalHotspot,
                              imageName: "personalhotspot"))
        }
        delegate?.reloadCollectionView()
    }
}

extension MenuViewModel {
    enum Row {
        case menu(title: String, imageName: String)
    }
    
    func row(for indexPath: IndexPath) -> Row {
        return rows[indexPath.row]
    }
}
