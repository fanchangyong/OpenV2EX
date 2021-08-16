import Foundation
import UIKit
import XCTest
@testable import Parchment

final class PagingViewControllerTests: XCTestCase {
  func testReloadMenu() {
    // Arrange
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()
    let dataSource = ReloadingDataSource()
    dataSource.viewControllers = [viewController0, viewController1]
    dataSource.items = [Item(index: 0), Item(index: 1)]
    
    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    let item2 = Item(index: 0)
    let item3 = Item(index: 1)
    let viewController2 = UIViewController()
    let viewController3 = UIViewController()
    
    dataSource.viewControllers = [viewController2, viewController3]
    dataSource.items = [item2, item3]
    
    pagingViewController.reloadMenu()
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    
    // Updates the cells
    let cell2 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ItemCell
    let cell3 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ItemCell
    XCTAssertEqual(pagingViewController.collectionView.numberOfItems(inSection: 0), 2)
    XCTAssertEqual(cell2?.item, item2)
    XCTAssertEqual(cell3?.item, item3)
    
    // Should not updated the view controllers
    XCTAssertEqual(pagingViewController.pageViewController.selectedViewController, viewController0)
  }
  
  func testReloadData() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()

    dataSource.viewControllers = [viewController0, viewController1]
    dataSource.items = [Item(index: 0), Item(index: 1)]

    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    let item2 = Item(index: 2)
    let item3 = Item(index: 3)
    let viewController2 = UIViewController()
    let viewController3 = UIViewController()

    dataSource.items = [item2, item3]
    dataSource.viewControllers = [viewController2, viewController3]
    pagingViewController.reloadData(around: item2)
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    let cell2 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ItemCell
    let cell3 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ItemCell

    XCTAssertEqual(cell2?.item, item2)
    XCTAssertEqual(cell3?.item, item3)
    XCTAssertEqual(pagingViewController.state, PagingState.selected(pagingItem: item2))
    XCTAssertEqual(pagingViewController.pageViewController.selectedViewController, viewController2)
  }
  
  func testReloadDataSameItemsUpdatesViewControllers() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()

    dataSource.viewControllers = [viewController0, viewController1]
    dataSource.items = [Item(index: 0), Item(index: 1)]

    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    let viewController2 = UIViewController()
    let viewController3 = UIViewController()

    dataSource.viewControllers = [viewController2, viewController3]
    pagingViewController.reloadData()
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    XCTAssertEqual(pagingViewController.pageViewController.selectedViewController, viewController2)
  }
  
  func testReloadDataSelectsPreviouslySelectedItem() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let item0 = Item(index: 0)
    let item1 = Item(index: 1)
    let item2 = Item(index: 2)
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()
    let viewController2 = UIViewController()

    dataSource.items = [item0, item1, item2]
    dataSource.viewControllers = [
      viewController0,
      viewController1,
      viewController2
    ]
    
    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    pagingViewController.select(index: 1)
    pagingViewController.view.layoutIfNeeded()

    pagingViewController.reloadData()
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    let cell0 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ItemCell
    let cell1 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ItemCell
    let cell2 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? ItemCell

    XCTAssertEqual(cell0?.item, item0)
    XCTAssertEqual(cell1?.item, item1)
    XCTAssertEqual(cell2?.item, item2)
    XCTAssertEqual(pagingViewController.state, PagingState.selected(pagingItem: item1))
  }
  
  func testReloadDataSelectsFirstItemForAllNewAllItems() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()

    dataSource.viewControllers = [viewController0, viewController1]
    dataSource.items = [Item(index: 0), Item(index: 1)]

    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    let item2 = Item(index: 2)
    let item3 = Item(index: 3)

    pagingViewController.select(index: 1)
    pagingViewController.view.layoutIfNeeded()

    dataSource.items = [item2, item3]
    pagingViewController.reloadData()
    pagingViewController.view.layoutIfNeeded()

    // Assert
    let cell2 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ItemCell
    let cell3 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ItemCell

    XCTAssertEqual(cell2?.item, item2)
    XCTAssertEqual(cell3?.item, item3)
    XCTAssertEqual(pagingViewController.state, PagingState.selected(pagingItem: item2))
  }
  
  func testReloadDataDisplayEmptyViewForNoItems() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let pagingViewController = PagingViewController()
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.dataSource = dataSource

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    pagingViewController.reloadData()

    // Assert
    XCTAssertEqual(pagingViewController.pageViewController.scrollView.subviews, [])
    XCTAssertEqual(pagingViewController.collectionView.numberOfItems(inSection: 0), 0)
  }
  
  func testReloadDataEmptyBeforeUsesWidthDelegate() {
    // Arrange
    let dataSource = ReloadingDataSource()
    let delegate = SizeDelegate()
    let pagingViewController = PagingViewController()
    pagingViewController.dataSource = dataSource
    pagingViewController.sizeDelegate = delegate
    pagingViewController.register(ItemCell.self, for: Item.self)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    let item0 = Item(index: 0)
    let item1 = Item(index: 1)
    dataSource.viewControllers = [UIViewController(), UIViewController()]
    dataSource.items = [item0, item1]
    pagingViewController.reloadData()
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    let cell0 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ItemCell
    let cell1 = pagingViewController.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? ItemCell

    XCTAssertEqual(cell0?.item, item0)
    XCTAssertEqual(cell1?.item, item1)
    XCTAssertEqual(cell0?.bounds.width, 100)
    XCTAssertEqual(cell1?.bounds.width, 50)
  }
  
  func selectFirstPagingItem() {
    // Arrange
    let dataSource = DataSource()
    let pagingViewController = PagingViewController()
    pagingViewController.register(ItemCell.self, for: Item.self)
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.infiniteDataSource = dataSource

    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    pagingViewController.select(pagingItem: Item(index: 0))
    
    // Assert
    let items = pagingViewController.collectionView.numberOfItems(inSection: 0)
    XCTAssertEqual(items, 21)
  }
  
  func selectCenterPagingItem() {
    // Arrange
    let dataSource = DataSource()
    let pagingViewController = PagingViewController()
    pagingViewController.register(ItemCell.self, for: Item.self)
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.infiniteDataSource = dataSource

    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    pagingViewController.select(pagingItem: Item(index: 20))
    
    // Assert
    let items = pagingViewController.collectionView.numberOfItems(inSection: 0)
    XCTAssertEqual(items, 21)
  }
  
  func selectLastPagingIteme() {
    // Arrange
    let dataSource = DataSource()
    let pagingViewController = PagingViewController()
    pagingViewController.register(ItemCell.self, for: Item.self)
    pagingViewController.menuItemSize = .fixed(width: 100, height: 50)
    pagingViewController.infiniteDataSource = dataSource

    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Act
    pagingViewController.select(pagingItem: Item(index: 50))
    
    // Assert
    let items = pagingViewController.collectionView.numberOfItems(inSection: 0)
    XCTAssertEqual(items, 21)
  }
  
  func testSelectIndexBeforeInitialRender() {
    // Arrange
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()
    let item0 = Item(index: 0)
    let item1 = Item(index: 1)

    let dataSource = ReloadingDataSource()
    dataSource.viewControllers = [viewController0, viewController1]
    dataSource.items = [item0, item1]

    let pagingViewController = PagingViewController()
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)
    
    // Act
    pagingViewController.select(index: 1)
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()
    
    // Assert
    XCTAssertEqual(pagingViewController.pageViewController.selectedViewController, viewController1)
    XCTAssertEqual(pagingViewController.collectionView.indexPathsForSelectedItems, [IndexPath(item: 1, section: 0)])
    XCTAssertEqual(pagingViewController.state, PagingState.selected(pagingItem: item1))
  }
  
  func testReloadDataBeforeInitialRender() {
    // Arrange
    let viewController0 = UIViewController()
    let viewController1 = UIViewController()
    let viewController2 = UIViewController()
    let item0 = Item(index: 0)
    let item1 = Item(index: 1)
    let item2 = Item(index: 2)

    let dataSource = ReloadingDataSource()
    dataSource.viewControllers = [viewController0, viewController1, viewController2]
    dataSource.items = [item0, item1, item2]

    let pagingViewController = PagingViewController()
    pagingViewController.dataSource = dataSource
    pagingViewController.register(ItemCell.self, for: Item.self)
    
    // Act
    pagingViewController.reloadData()
    pagingViewController.select(index: 1)

    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1000, height: 50))
    window.rootViewController = pagingViewController
    window.makeKeyAndVisible()
    pagingViewController.view.layoutIfNeeded()

    // Assert
    XCTAssertEqual(pagingViewController.pageViewController.selectedViewController, viewController1)
    XCTAssertEqual(pagingViewController.collectionView.indexPathsForSelectedItems, [IndexPath(item: 1, section: 0)])
    XCTAssertEqual(pagingViewController.state, PagingState.selected(pagingItem: item1))
  }
  
  func testRetainCycles() {
    var instance: DeinitPagingViewController? = DeinitPagingViewController()
    let expectation = XCTestExpectation()
    
    instance?.deinitCalled = {
      expectation.fulfill()
    }
    DispatchQueue.global(qos: .background).async {
      instance = nil
    }
    
    wait(for: [expectation], timeout: 2)
  }
}

private class DataSource: PagingViewControllerInfiniteDataSource {
  func pagingViewController(_: PagingViewController, itemAfter: PagingItem) -> PagingItem? {
    guard let item = itemAfter as? Item else { return nil }
    if item.index < 50 {
      return Item(index: item.index + 1)
    }
    return nil
  }
  
  func pagingViewController(_: PagingViewController, itemBefore: PagingItem) -> PagingItem? {
    guard let item = itemBefore as? Item else { return nil }
    if item.index > 0 {
      return Item(index: item.index - 1)
    }
    return nil
  }
  
  func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
    return UIViewController()
  }
}

private class SizeDelegate: PagingViewControllerSizeDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
    guard let item = pagingItem as? Item else { return 0 }
    if item.index == 0 {
      return 100
    } else {
      return 50
    }
  }
}

private class DeinitPagingViewController: PagingViewController {
  var deinitCalled: (() -> Void)?
  deinit { deinitCalled?() }
}

private class ReloadingDataSource: PagingViewControllerDataSource {
  var items: [Item] = []
  var viewControllers: [UIViewController] = []
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return items.count
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    return viewControllers[index]
  }
  
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return items[index]
  }
}
