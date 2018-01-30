//
//  Meal.swift
//  FoodTracker
//
//  Created by Yuhei Kikuchi on 2018/01/07.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {

    // MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: Archiving Paths

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

    static func getArchiveURL() -> URL? {
        LogUtil.traceFunc()

        let urls = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            return url.appendingPathComponent("meal")
        } else {
            return nil
        }
    }

    // MARK: Types
    struct PropertyKey {
        static let name  = "name"
        static let photo = "photo"
        static let rating = "rating"
    }

    // MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        LogUtil.traceFunc(params: ["name" : name,
                                   "photo" : photo!,
                                   "rating" : rating])

        // The name must not be empty
        guard !name.isEmpty else {
            LogUtil.debug("name is empty")
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (0 <= rating) && (rating <= 5) else {
            LogUtil.debug("rating is out of bounds")
            return nil
        }

        // Initialize stored properties
        self.name   = name
        self.photo  = photo
        self.rating = rating
    }

    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        LogUtil.traceFunc()

        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        LogUtil.traceFunc(params: ["coder" : aDecoder])

        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            LogUtil.debug("Unable to decode the name for a Meal object.")
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }

        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage

        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)

        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
}
