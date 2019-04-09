//
//  Download.swift
//  HalfTunes
//
//  Created by Jose on 2/11/18.
//  Copyright © 2018 appcat.com. All rights reserved.
//

import Foundation

class Download
{
	var track: Track
	var task: URLSessionDownloadTask?
	var isDownloading = false
	var resumeData: Data?
	var progress: Float = 0

	init(track: Track)
	{
		self.track = track
	}
}
