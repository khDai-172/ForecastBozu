import Alamofire
import UIKit

public struct AlamofirePack {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    public static func fetchAPIuseAlamofire(from url: String, onSuccess: @escaping (String) -> Void,
                                     onFail: @escaping (Error?) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let data = String(data: data, encoding: .utf8)
                onSuccess(data ?? "Success")
            case .failure(let errordetected):
                onFail(errordetected)
            }
        }
    }
}
