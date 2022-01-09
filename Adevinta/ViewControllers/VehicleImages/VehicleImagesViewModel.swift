//
//  VehicleImagesViewModel.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit
import Combine

final class VehicleImagesViewModel {

    @Published var searchText: String = "333298695"
    @Published private (set) var isLoading: Bool = false
    @Published private (set) var snapshot = NSDiffableDataSourceSnapshot<Int, VehicleImageItem>()
    private var vehicleDetailsCancellable: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()
    private let presenter: Presenting

    let vehicleDetailsController: VehicleDetailsControllerProtocol

    init(
        presenter: Presenting,
        vehicleDetailsController: VehicleDetailsControllerProtocol = VehicleDetailsController()
    ) {
        self.presenter = presenter
        self.vehicleDetailsController = vehicleDetailsController
        setupSubscriptions()
    }

    func setupSubscriptions() {
        vehicleDetailsCancellable?.cancel()
        $searchText.sink { [weak self] searchText in
            self?.getVehicleDetails(vehicleId: searchText)
        }.store(in: &subscriptions)
    }

    func getVehicleDetails(vehicleId: String) {
        isLoading = true
        snapshot = makeSnapshot(from: [])
        vehicleDetailsCancellable?.cancel()
        vehicleDetailsCancellable = vehicleDetailsController.getVehicleDetails(id: vehicleId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] (completion) in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.showAlert(title: "Ooups", message: error.localizedDescription)
                case .finished: break
                }
            }) { [weak self] vehicleDetails in
                guard let self = self else { return }
                let uris = vehicleDetails.images?.compactMap({ $0.uri }) ?? []
                self.snapshot = self.makeSnapshot(from: uris)
                if uris.isEmpty {
                    self.showAlert(title: "Ooups", message: "No images found for vehicle id\n \(vehicleId)")
                }
            }
        vehicleDetailsCancellable?.store(in: &subscriptions)
    }

    func showPageImageViewController(selectedUri: String) {
        let imageUris = snapshot.itemIdentifiers.map { $0.uri }
        let pageImageScreen = PageImageScreen(selectedUri: selectedUri, imageUris: imageUris)
        presenter.show(pageImageScreen, presentation: .present, animated: true)
    }

    func showAlert(title: String?, message: String?) {
        let alertScreen = AlertScreen(title: title, message: message)
        presenter.show(alertScreen, presentation: .present, animated: true)
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
