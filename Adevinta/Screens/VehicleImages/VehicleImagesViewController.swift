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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentVehicleDetails()
    }

    func showPageImageViewController(selectedUri: String) {
        let imageUris = dataSource.snapshot().itemIdentifiers.map { $0.uri }
        let viewModel = ImagePageViewModel(initialUri: selectedUri, imageUris: imageUris)
        let viewController = ImagePageViewController(viewModel: viewModel)
        present(viewController, animated: true)
    }

}

// MARK: - UICollectionViewDelegate
extension VehicleImagesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedUri = dataSource.itemIdentifier(for: indexPath)?.uri else { return }
        showPageImageViewController(selectedUri: selectedUri)
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
        collectionView.delegate = self
    }

}

// MARK: - Subscriptions Setup
private extension VehicleImagesViewController {

    func getCurrentVehicleDetails() {

        let loadingController = LoadingViewController()
        loadingController.modalTransitionStyle = .crossDissolve
        loadingController.modalPresentationStyle = .fullScreen

        let vehicleDetailsPub = viewModel.vehicleDetailsController.getVehicleDetails(id: "333298695")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    print("Couldn't get vehicleDetails: \(error)")
                case .finished: break
                }
            }) { [weak self] vehicleDetails in
                guard let self = self else { return }
                let uris = vehicleDetails.images?.compactMap({ $0.uri }) ?? []
                let snapshot = self.viewModel.makeSnapshot(from: uris)
                self.dataSource.apply(snapshot)
//                self.dataSource.snapshot().itemIdentifiers
            }

        vehicleDetailsPub
            .store(in: &subscriptions)

//        vehicleDetailsPub.cancel()

    }

}


final class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

    }
    
}
