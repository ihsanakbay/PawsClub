//
//  BreedService.swift
//  PawsClub
//
//  Created by İhsan Akbay on 3.09.2022.
//

import Foundation

enum NetworkServiceError: Error {
	case failed
	case failedToDecode
	case invalidStatusCode
	case invalidUrl
	case invalidServerResponse
}

protocol BreedService {
	func download(_ resource: String) async throws -> Result<Breed, Error>
}

final class BreedRepository: BreedService {
	func download(_ resource: String) async throws ->  Result<Breed, Error>  {
		guard let url = URL(string: resource) else { throw NetworkServiceError.invalidUrl }

		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
			throw NetworkServiceError.invalidServerResponse
		}
		
		do {
			let result = try JSONDecoder().decode(Breed.self, from: data)
			return .success(result)
		} catch {
			return .failure(error)
		}
	}
}
