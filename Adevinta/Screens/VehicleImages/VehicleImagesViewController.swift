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
    private var loadingViewController: LoadingViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubscriptions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentVehicleDetails()
    }

    func showPageImageViewController(selectedUri: String) {
        let imageUris = dataSource.snapshot().itemIdentifiers.map { $0.uri }
        let viewModel = ImagePageViewModel(initialUri: selectedUri, imageUris: imageUris)
        let viewController = ImagePageViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
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

    func setupSubscriptions() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showImages(for: [])
                let loadingViewController = LoadingViewController()
                self.addChildViewController(loadingViewController)
                self.loadingViewController = loadingViewController
            } else {
                self.loadingViewController?.removeAsChild()
                self.loadingViewController = nil
            }
        }.store(in: &subscriptions)

    }

    func getCurrentVehicleDetails() {

        // 333298695
        viewModel.isLoading = true
        let vehicleDetailsPub = viewModel.vehicleDetailsController.getVehicleDetails(id: "333298695")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] (completion) in
                guard let self = self else { return }
                self.viewModel.isLoading = false
                switch completion {
                case let .failure(error):
                    self.showAlert(title: "Ooups", message: error.localizedDescription)
                case .finished: break
                }
            }) { [weak self] vehicleDetails in
                guard let self = self else { return }
                let uris = vehicleDetails.images?.compactMap({ $0.uri }) ?? []
                self.showImages(for: uris)
                if uris.isEmpty {
                    self.showAlert(title: "Ooups", message: "No images found")
                }
            }

        vehicleDetailsPub
            .store(in: &subscriptions)

//        vehicleDetailsPub.cancel()

    }

    func showImages(for uris: [String]) {
        let snapshot = self.viewModel.makeSnapshot(from: uris)
        dataSource.apply(snapshot)
    }

}
