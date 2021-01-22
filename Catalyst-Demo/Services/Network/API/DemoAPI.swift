//
//  DemoAPI.swift
//  Catalyst-Demo
//
//  Created by Nutan Niraula on 14/10/20.
//

import Alamofire

final class DemoAPI: API {

    enum ErrorResponse: Decodable {
        case singleErrorResponse(SingleErrorResponse)
        case errorArray(ErrorArrayResponse)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            do {
                let data = try container.decode(SingleErrorResponse.self)
                self = .singleErrorResponse(data)
            } catch {
                let data = try container.decode(ErrorArrayResponse.self)
                self = .errorArray(data)
            }
        }
    }

    struct SingleErrorResponse: Decodable {
        struct DeeMoneyAPIErrorModel: Decodable {
            let detail: String
        }

        let errors: DeeMoneyAPIErrorModel
    }

    struct ErrorArrayResponse: Decodable {
        struct DeeMoneyMobileErrorModel: Decodable {
            let mobileError: [String]

            //swiftlint:disable:next nesting
            private enum CodingKeys: String, CodingKey {
                case mobileError = "mobile"
            }
        }

        let errors: DeeMoneyMobileErrorModel
    }

    let baseURL: String
    let session: Session
    private let parser: JSONDecoder

    init(
        baseURL: String,
        parser: JSONDecoder
    ) {
        self.baseURL = baseURL
        self.parser = parser
        let sessionConfiguration = URLSessionConfiguration.af.default
        sessionConfiguration.timeoutIntervalForRequest = 60.0
        sessionConfiguration.timeoutIntervalForResource = 120.0

        session = Session(configuration: sessionConfiguration)
    }

    func url(forEndpoint endpoint: String) -> String {
        let url = URL(string: baseURL)?.appendingPathComponent(endpoint, isDirectory: false)
        return url?.absoluteString ?? baseURL
    }

    func url(forEndpoint endpoint: String, baseURL: String) -> String {
        let url = URL(string: baseURL)?.appendingPathComponent(endpoint, isDirectory: false)
        return url?.absoluteString ?? baseURL
    }

    func performRequest(
        with configuration: RequestConfiguration,
        completion: @escaping RequestCompletion<Data>
    ) -> Request {
        session.request(
            configuration.url,
            method: configuration.method,
            parameters: configuration.parameters,
            encoding: configuration.parameterEncoding,
            headers: configuration.headers
        )
        .validate(statusCode: 200...599)
        .responseData { [weak self] dataResponse in
            guard let self = self else { return }
            switch dataResponse.result {
            case .success(let data):
                guard let statusCode = dataResponse.response?.statusCode else {
                    return completion(.failure(APIError.genericError))
                }
                if 200 ... 299 ~= statusCode {
                    completion(.success(data))
                } else {
                    completion(.failure(self.parseAPIError(from: data)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func parseAPIError(from data: Data) -> Error {
        do {
            let errorResponse = try self.parser.decode(DataWrappedResponse<ErrorResponse>.self, from: data)
            let message = self.getErrorMessage(from: errorResponse.data)
            return APIError.apiError(detail: message)
        } catch {
            return error
        }
    }

    private func getErrorMessage(from response: ErrorResponse) -> String {
        switch response {
        case .singleErrorResponse(let errorModel):
            return errorModel.errors.detail
        case .errorArray(let errorModel):
            guard let firstErrorMessage = errorModel.errors.mobileError.first else {
                return ""
            }
            return firstErrorMessage
        }
    }
}
