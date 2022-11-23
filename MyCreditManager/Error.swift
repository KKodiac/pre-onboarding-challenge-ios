//
//  Error.swift
//  MyCreditManager
//
//  Created by Sean Hong on 2022/11/23.
//

import Foundation

enum Error: Swift.Error {
    case invalidName(String)
    case invalidNameEmpty
    case invalidCourse(String)
    case invalidCredit(String)
    case nameRecordNotFound(String)
    case nameRecordExists(String)
    case courseRecordNotFound(String, String)
    case notEnoughInput
}

extension Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCourse(let course):
            return "\(course)은(는) 정확한 과목 이름이 아닙니다."
        case .invalidName(let name):
            return "\(name)은(는) 정확한 학생 이름이 아닙니다. 입력이 잘못되었습니다. 다시 확인해주세요."
        case .invalidNameEmpty:
            return "빈 문자열이 입력되었습니다. 입력이 잘못되었습니다. 다시 확인해주세요."
        case .invalidCredit(let credit):
            return "\(credit)은(는) 정확한 성적이 아닙니다."
        case .nameRecordNotFound(let name):
            return "\(name)은(는) 레코드에 존재하지 않는 학생입니다."
        case .nameRecordExists(let name):
            return "\(name)은(는) 이미 레코드에 존재하는 학생입니다."
        case .courseRecordNotFound(let name, let course):
            return "\(name) 학생의 \(course) 성적은 레코드에 존재하지 않습니다."
        case .notEnoughInput:
            return "입력의 개수가 충분하지 않아요. 입력이 잘못되었습니다. 다시 확인해주세요."
        }
    }
}
