//
//  VehicleImagesViewController.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit

final class VehicleImagesViewController: UIViewController {

    private lazy var viewModel = VehicleImagesViewModel(presenter: Presenter(originViewController: self))
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: viewModel.makeLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.setupDataSource(for: collectionView)
    }

}

// MARK: - UICollectionViewDelegate
extension VehicleImagesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }

}

// MARK: - UISearchBarDelegate
extension VehicleImagesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarSearchButtonClicked()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarCancelButtonClicked()
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
        navigationItem.searchController = viewModel.searchController
        viewModel.searchController.searchBar.delegate = self
    }

    func setupInfoButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: UIButton(type: .infoLight, primaryAction: viewModel.makeInfoAction())
        )
    }

    func setupLoadingActivityIndicatorView() {
        view.addSubview(viewModel.loadingActivityIndicator)
        viewModel.loadingActivityIndicator.activateCenterConstraints(relativeTo: collectionView)
    }

}
