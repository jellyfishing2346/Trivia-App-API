//
//  String+Extensions.swift
//  Trivia
//
//  Created by Faizan Khan on 3/21/25.
//

// String+Extensions.swift
import Foundation

extension String {
    var decodedHTMLString: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}
