
import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate
{
  @objc func dismissKeyboard()
	{
    searchBar.resignFirstResponder()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
	{
    dismissKeyboard()
		
    guard let searchText = searchBar.text, !searchText.isEmpty else { return }
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
    queryService.getSearchResults(searchTerm: searchText)
		{ results, errorMessage in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      if let results = results
			{
        self.searchResults = results
        self.tableView.reloadData()
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
      }
      if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
    }
  }

  func position(for bar: UIBarPositioning) -> UIBarPosition
	{
    return .topAttached
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
	{
    view.addGestureRecognizer(tapRecognizer)
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
	{
    view.removeGestureRecognizer(tapRecognizer)
  }
}
