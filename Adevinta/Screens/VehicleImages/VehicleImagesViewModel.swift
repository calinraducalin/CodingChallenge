//
//  VehicleImagesViewModel.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import Foundation
import UIKit

final class VehicleImagesViewModel {

    @Published var isLoading: Bool = false
    let vehicleDetailsController: VehicleDetailsControllerProtocol
    let vehicleCellRegistration = UICollectionView.CellRegistration<VehicleImageCell, VehicleImageItem> { (cell, _, item) in
        cell.update(with: item)
    }

    init(vehicleDetailsController: VehicleDetailsControllerProtocol = VehicleDetailsController()) {
        self.vehicleDetailsController = vehicleDetailsController
    }

    func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.36)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func makeSnapshot(from uris: [String]) -> NSDiffableDataSourceSnapshot<Int, VehicleImageItem> {
        let items = uris.map { VehicleImageItem(uri: $0) }
        var snapshot = NSDiffableDataSourceSnapshot<Int, VehicleImageItem>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items, toSection: .zero)

        return snapshot
    }
    
}
