//
//  VehicleImagesViewController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit
import Combine

final class VehicleImagesViewController: UIViewController {

    private var subscriptions = Set<AnyCancellable>()
    private lazy var viewModel = VehicleImagesViewModel(presenter: Presenter(originViewController: self))
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: viewModel.makeLayout())
    private let vehicleCellRegistration = UICollectionView.CellRegistration<VehicleImageCell, VehicleImageItem> { (cell, _, item) in
        cell.update(with: item)
    }
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, VehicleImageItem>(
        collectionView: collectionView
    ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let self = self else { return nil }
        return collectionView
            .dequeueConfiguredReusableCell(using: self.vehicleCellRegistration, for: indexPath, item: item)
    }
    private let loadingActivityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubscriptions()
    }

}

// MARK: - UICollectionViewDelegate
extension VehicleImagesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedUri = dataSource.itemIdentifier(for: indexPath)?.uri else { return }
        viewModel.showPageImageViewController(selectedUri: selectedUri)
    }

}

// MARK: - UISearchBarDelegate
extension VehicleImagesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchText = searchText
        searchController.isActive = false
        DispatchQueue.main.async {
            self.searchController.searchBar.text = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        DispatchQueue.main.async {
            self.searchController.searchBar.text = searchText
        }
    }

}

// MARK: - View Setup
private extension VehicleImagesViewController {

    func setupView() {
        setupInfoButton()
        setupCollectionView()
        setupSearchController()
        setupLoadingActivityIndicatorView()
    }

    func setupCollectionView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }

    func setupInfoButton() {
        let infoAction = UIAction { [weak self] _ in
            self?.viewModel.showAlert(title: "Project Info", message: "Project Message")
        }
        navigationItem.rightBarButtonItem = .init(customView: UIButton(type: .infoLight, primaryAction: infoAction))
    }

    func setupLoadingActivityIndicatorView() {
        loadingActivityIndicator.hidesWhenStopped = true
        view.addSubview(loadingActivityIndicator)
        loadingActivityIndicator.activateCenterConstraints(relativeTo: collectionView)
    }

}

// MARK: - Subscriptions Setup
private extension VehicleImagesViewController {

    func setupSubscriptions() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.loadingActivityIndicator.startAnimating()
            } else {
                self?.loadingActivityIndicator.stopAnimating()
            }
        }.store(in: &subscriptions)

        viewModel.$snapshot.sink { [weak self] snapshot in
            self?.dataSource.apply(snapshot)
        }.store(in: &subscriptions)

        viewModel.$searchText.sink { [weak self] searchText in
            self?.searchController.searchBar.text = searchText
        }.store(in: &subscriptions)
    }

}
