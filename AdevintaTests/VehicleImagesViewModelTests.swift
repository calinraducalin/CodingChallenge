//
//  VehicleImagesViewModelTests.swift
//  VehicleImagesViewModelTests
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import XCTest
import Combine
@testable import Adevinta

class VehicleImagesViewModelTests: XCTestCase {

    var presenter: PresenterMock!
    var searchController: UISearchController!
    var activityIndicator: ActivityIndicatorMock!
    var vehicleDetailsController: VehicleDetailsControllerMock!
    var collectionView: UICollectionView!
    var subscriptions: Set<AnyCancellable>!
    var viewModel: VehicleImagesViewModel!
    var dataSource: UICollectionViewDiffableDataSource<Int, VehicleImageItem>! { collectionView.dataSource as? UICollectionViewDiffableDataSource<Int, VehicleImageItem> }

    override func setUp() {
        super.setUp()
        presenter = PresenterMock()
        searchController = UISearchController()
        activityIndicator = ActivityIndicatorMock()
        vehicleDetailsController = VehicleDetailsControllerMock()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        subscriptions = Set<AnyCancellable>()

        viewModel = VehicleImagesViewModel(
            presenter: presenter, searchController: searchController, activityIndicator: activityIndicator, vehicleDetailsController: vehicleDetailsController
        )
    }

    func testThatDataSourceIsSetAfterSetup() {
        //Given
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        //When
        viewModel.setupDataSource(for: collectionView)
        //Then
        XCTAssertTrue(collectionView.dataSource is UICollectionViewDiffableDataSource<Int, VehicleImageItem>, "Data Source is not set")
    }

    func testMakeLayout() {
        //When
        let layout = viewModel.makeLayout()
        //Then
        XCTAssertTrue(layout is UICollectionViewCompositionalLayout, "Layout should be of type UICollectionViewCompositionalLayout")
    }

    func testMakeInfoActionHandler() {
        //Given
        let button = UIButton(primaryAction: viewModel.makeInfoAction())
        //When
        button.sendActions(for: .touchUpInside)
        //Then
        XCTAssertTrue(presenter.screen is AlertScreen)
        XCTAssertTrue(presenter.presentation == Presentation.present)
    }

    func testThatSearchBarTextIsCorrectWhenSearchingDefaultVehicle() {
        //When
        viewModel.searchDefaultVehicle()
        //Then
        XCTAssertTrue(searchController.searchBar.text == "333298695")
    }

    func testThatGetVehicleDetailsPublisherIsTriggeredWhenSearchingDefaultVehicle() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")

        //When
        viewModel.searchDefaultVehicle()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertNotNil(viewModel.vehicleDetailsPublisher)
    }

    func testThatPageImageScreenIsPresentedWhenDidSelectItemIsCalled() {
        //Given
        viewModel.setupDataSource(for: collectionView)
        let vehicleId = vehicleDetailsController.imagesId
        searchController.searchBar.text = vehicleId
        viewModel.searchBarSearchButtonClicked()
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
        waitForExpectations(timeout: 1, handler: nil)
        //When
        viewModel.didSelectItem(at: IndexPath(item: .zero, section: .zero))
        //Then
        XCTAssertTrue(presenter.screen is PageImageScreen)
        XCTAssertTrue(presenter.presentation == .present)
    }

    func testSearchBarCancelButtonClicked() {
        //Given
        searchController.searchBar.text = "Test"
        //When
        viewModel.searchBarCancelButtonClicked()
        //Then
        XCTAssertTrue(searchController.searchBar.text == "Test", "Search test should not be change when Cancel is pressed")
    }

    func testThatLoadingIsStartedWhenSearchButtonIsClicked() {
        //Given
        searchController.searchBar.text = "Test"
        activityIndicator.startAnimatingCalled = false
        //When
        viewModel.searchBarSearchButtonClicked()
        //Then
        XCTAssertTrue(activityIndicator.startAnimatingCalled)
        XCTAssertFalse(activityIndicator.stopAnimatingCalled)
    }

    func testThatSnaposhotIsEmptyWhenSearchButtonIsClicked() {
        //Given
        viewModel.setupDataSource(for: collectionView)
        searchController.searchBar.text = "Test"
        //When
        viewModel.searchBarSearchButtonClicked()
        //Then
        XCTAssertTrue(dataSource.snapshot().numberOfItems == .zero)
    }

    func testThatVehicleDetailsPublisherIsUpdatedWhenSearchButtonIsClicked() {
        //Given
        searchController.searchBar.text = "Test"
        //When
        viewModel.searchBarSearchButtonClicked()
        //Then
        XCTAssertNotNil(viewModel.vehicleDetailsPublisher)
    }

    func testThatLoadingIsStoppedWhenVehicleDetailsResponseSuccesssIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.emptyImagesId

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(activityIndicator.stopAnimatingCalled, "Activity Indicator should stop when vehicle details response is received")
    }

    func testThatLoadingIsStoppedWhenVehicleDetailsResponseErrorIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.errorId

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(activityIndicator.stopAnimatingCalled, "Activity Indicator should stop when vehicle details response is received")
    }

    func testThatAlertIsPresentedWhenErrorIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.errorId

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(presenter.screen is AlertScreen)
        XCTAssertTrue(presenter.presentation == .present)
    }

    func testThatAlertIsPresentedWhenSuccessWithEmptyImagesIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.emptyImagesId

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(presenter.screen is AlertScreen)
        XCTAssertTrue(presenter.presentation == .present)
    }

    func testThatSnapshotIsEmptyWhenSuccessWithEmptyImagesIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.emptyImagesId
        viewModel.setupDataSource(for: collectionView)

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(dataSource.snapshot().numberOfItems == .zero)
    }

    func testThatSnapshotIsNotEmptyWhenSuccessWithImagesIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.imagesId
        viewModel.setupDataSource(for: collectionView)

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertTrue(dataSource.snapshot().numberOfItems != .zero)
    }

    func testThatNoAlertIsPresentedWhenSuccessWithImagesIsReceived() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.imagesId

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertNil(presenter.screen)
        XCTAssertNil(presenter.presentation)
    }

    func testThatSubscriptionsIsNotEmptyAfterSearchButtonIsClicked() {
        //Given
        let expectation = self.expectation(description: "VehicleDetailsResponse")
        searchController.searchBar.text = vehicleDetailsController.imagesId
        XCTAssertTrue(viewModel.subscriptions.isEmpty)

        //When
        viewModel.searchBarSearchButtonClicked()
        viewModel.vehicleDetailsPublisher?
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1, handler: nil)

        //Then
        XCTAssertFalse(viewModel.subscriptions.isEmpty)
    }
}
