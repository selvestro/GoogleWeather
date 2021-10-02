//
//  GoogleWeatherTests.swift
//  GoogleWeatherTests
//
//  Created by Dmitry Seliverstov on 01.10.2021.
//

import XCTest
@testable import GoogleWeather
@testable import WeatherCore

class GoogleWeatherTests: XCTestCase {

    var expectCurrent: XCTestExpectation?

    override func setUpWithError() throws {
        DarkSky_Key = "3e7e519ea86c8e3fcf67c0f4870513d7"
    }

    override func tearDownWithError() throws {}

    func testPerformanceExample() throws {
        self.measure {}
    }
    
    func testAPIForecast() throws {
        expectCurrent = expectation(description: "DarkSkyTests_testAPIForecast")
        guard let urlString = "https://api.darksky.net/forecast/\(DarkSky_Key)/55.753913,37.620836"
                .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        else {
            fatalError()
        }
        print("DarkSkyTests_testAPIForecast_urlString \(urlString)")
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { responseData, response, error in
            guard error == nil else {
                let err = "\nERROR_DarkSkyTests_testAPIForecast \(String(describing: error))"
                XCTFail(err)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            let headers = httpResponse.allHeaderFields
            print(headers)
            guard let data = responseData else {
                return
            }
            print(data)
            let decoder = JSONDecoder()
            do {
                let resp = try decoder.decode(DarkSky.Response.self, from: data)
                print(resp)
                self.expectCurrent?.fulfill()
            } catch {
                XCTFail("ERROR_DarkSkyTests_testAPIForecast_response \(error)")
            }
        }.resume()
        waitForExpectations(timeout: 10) { error in }
    }
}
