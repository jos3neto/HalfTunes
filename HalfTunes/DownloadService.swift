
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
    guard let download = activeDownloads[track.previewURL] else { return }
		guard download.isDownloading else {return}
		
		download.task?.cancel(byProducingResumeData:
		{ data in
			download.resumeData = data
		})
		download.isDownloading = false
	}

  func cancelDownload(_ track: Track)
	{
		guard let download = activeDownloads[track.previewURL] else {return}
		download.task?.cancel()
		activeDownloads[track.previewURL] = nil
  }

  func resumeDownload(_ track: Track)
	{
    guard let download = activeDownloads[track.previewURL] else { return }
		if let resumeData = download.resumeData
		{
			download.task = downloadSession.downloadTask(withResumeData: resumeData)
		} else
		{
			download.task = downloadSession.downloadTask(with: download.track.previewURL)
		}
		download.task!.resume()
		download.isDownloading = true
  }
}
