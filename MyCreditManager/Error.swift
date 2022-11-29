//
//  Error.swift
//  MyCreditManager
//
//  Created by Sean Hong on 2022/11/23.
//

import Foundation

enum Error: Swift.Error {
    case invalidName
    case invalidCourse(String)
    case invalidCredit(String)
    case nameRecordExists(String)
    case recordNotFound
    case notEnoughInput
}

extension Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCourse(let course):
            return "\(course)은(는) 정확한 과목 이름이 아닙니다."
        case .invalidName:
            return "정확한 학생 이름이 아닙니다. 입력이 잘못되었습니다. 다시 확인해주세요."
        case .invalidCredit(let credit):
            return "\(credit)은(는) 정확한 성적이 아닙니다."
        case .nameRecordExists(let name):
            return "\(name)은(는) 이미 레코드에 존재하는 학생입니다."
        case .recordNotFound:
            return "값이 레코드에 존재하지 않습니다."
        case .notEnoughInput:
            return "입력의 개수가 충분하지 않아요. 입력이 잘못되었습니다. 다시 확인해주세요."
        }
    }
}
