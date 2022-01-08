//
//  VehicleImagesViewController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit
import Combine

final class VehicleImagesViewController: UIViewController {

    private let viewModel = VehicleImagesViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: viewModel.makeLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, VehicleImageItem>(
        collectionView: collectionView
    ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let self = self else { return nil }
        return collectionView
            .dequeueConfiguredReusableCell(using: self.viewModel.vehicleCellRegistration, for: indexPath, item: item)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubscriptions()
    }


}

// MARK: - View Setup
private extension VehicleImagesViewController {

    func setupView() {
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }

}

// MARK: - Subscriptions Setup
private extension VehicleImagesViewController {

    func setupSubscriptions() {

        viewModel.vehicleDetailsController.getVehicleDetails(id: "333298695")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    print("Couldn't get vehicleDetails: \(error)")
                case .finished: break
                }
            }) { [weak self] vehicleDetails in
                guard let self = self else { return }
                if let uris = vehicleDetails.images?.compactMap({ $0.uri }) {
                    let snapshot = self.viewModel.makeSnapshot(from: uris)
                    self.dataSource.apply(snapshot)
                }
            }
            .store(in: &subscriptions)
    }

}
