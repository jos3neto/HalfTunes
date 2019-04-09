
import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService
{
  // SearchViewController creates downloadsSession
  var downloadSession: URLSession!
	var activeDownloads: [URL:Download] = [:]

  // MARK: - Download methods called by TrackCell delegate methods

  func startDownload(_ track: Track)
	{
		let download = Download(track: track)
		download.task = downloadSession.downloadTask(with: track.previewURL)
	
		download.task!.resume()
	
		download.isDownloading = true
		activeDownloads[download.track.previewURL] = download
	}
  // TODO: previewURL is http://a902.phobos.apple.com/...
  // why doesn't ATS prevent this download?

  func pauseDownload(_ track: Track)
	{
    // TODO
  }

  func cancelDownload(_ track: Track)
	{
    // TODO
  }

  func resumeDownload(_ track: Track)
	{
    // TODO
  }
}
