//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

enum FeedImageMapper {
	struct Root: Decodable {
		let items: [Item]

		var feed: [FeedImage] {
			items.map(\.item)
		}
	}

	struct Item: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var item: FeedImage {
			return FeedImage(id: image_id,
			                 description: image_desc,
			                 location: image_loc,
			                 url: image_url)
		}
	}

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == 200,
		      let root = try? JSONDecoder().decode(Root.self, from: data)
		else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.feed)
	}
}
