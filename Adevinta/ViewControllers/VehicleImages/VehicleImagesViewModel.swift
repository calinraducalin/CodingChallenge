//
//  VehicleImagesViewModel.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit
import Combine

final class VehicleImagesViewModel {

    let searchController: UISearchController
    let activityIndicator: UIActivityIndicatorView
    private let presenter: Presenting
    private let vehicleDetailsController: VehicleDetailsControllerProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var vehicleDetailsCancellable: AnyCancellable?
    private var dataSource: UICollectionViewDiffableDataSource<Int, VehicleImageItem>?
    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    private let vehicleCellRegistration = UICollectionView.CellRegistration<VehicleImageCell, VehicleImageItem> { (cell, _, item) in
        cell.update(with: item)
    }

    init(
        presenter: Presenting,
        searchController: UISearchController = .init(),
        activityIndicator: UIActivityIndicatorView = .init(),
        vehicleDetailsController: VehicleDetailsControllerProtocol = VehicleDetailsController()
    ) {
        self.presenter = presenter
        self.vehicleDetailsController = vehicleDetailsController
        self.searchController = searchController
        self.activityIndicator = activityIndicator

        activityIndicator.hidesWhenStopped = true
    }

    func setupDataSource(for collectionView: UICollectionView) {
        self.dataSource = UICollectionViewDiffableDataSource<Int, VehicleImageItem>(
            collectionView: collectionView
        ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            return collectionView
                .dequeueConfiguredReusableCell(using: self.vehicleCellRegistration, for: indexPath, item: item)
        }
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

    func makeInfoAction() -> UIAction {
        UIAction { [weak self] _ in
            self?.showAlert(title: "Project Info", message: "Project Message")
        }
    }

    func searchDefaultVehicle() {
        let searchText = "333298695"
        getVehicleDetails(vehicleId: searchText)
        searchController.searchBar.text = searchText
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let selectedUri = dataSource?.itemIdentifier(for: indexPath)?.uri else { return }
        showPageImageViewController(selectedUri: selectedUri)
    }

    func searchBarSearchButtonClicked() {
        guard let searchText = searchController.searchBar.text else { return }
        getVehicleDetails(vehicleId: searchText)
        searchController.isActive = false
        DispatchQueue.main.async {
            self.searchController.searchBar.text = searchText
        }
    }

    func searchBarCancelButtonClicked() {
        guard let searchText = searchController.searchBar.text else { return }
        DispatchQueue.main.async {
            self.searchController.searchBar.text = searchText
        }
    }
    
}

private extension VehicleImagesViewModel {

    func getVehicleDetails(vehicleId: String) {
        isLoading = true
        applySnapshot(for: [])
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
                self.applySnapshot(for: uris)
                if uris.isEmpty {
                    self.showAlert(title: "Ooups", message: "No images found for vehicle id\n \(vehicleId)")
                }
            }
        vehicleDetailsCancellable?.store(in: &subscriptions)
    }

    func makeSnapshot(from uris: [String]) -> NSDiffableDataSourceSnapshot<Int, VehicleImageItem> {
        let items = uris.map { VehicleImageItem(uri: $0) }
        var snapshot = NSDiffableDataSourceSnapshot<Int, VehicleImageItem>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items, toSection: .zero)

        return snapshot
    }

    func showPageImageViewController(selectedUri: String) {
        let imageUris = dataSource?.snapshot().itemIdentifiers.map { $0.uri } ?? []
        let pageImageScreen = PageImageScreen(selectedUri: selectedUri, imageUris: imageUris)
        presenter.show(pageImageScreen, presentation: .present, animated: true)
    }

    func showAlert(title: String?, message: String?) {
        let alertScreen = AlertScreen(title: title, message: message)
        presenter.show(alertScreen, presentation: .present, animated: true)
    }

    func applySnapshot(for uris: [String]) {
        let snapshot = self.makeSnapshot(from: uris)
        self.dataSource?.apply(snapshot)
    }

}
