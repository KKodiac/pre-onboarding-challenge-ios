//
//  Message.swift
//  MyCreditManager
//
//  Created by Sean Hong on 2022/11/25.
//

import Foundation

enum Message {
    case appendStudentMessage
    case removeStudentMessage
    case appendCreditMessage
    case removeCreditMessage
    case peekCreditMessage
    case mainMessage
    case mainErrorMessage
    case quitMessage
    case insertCompletionMessage(String)
    case insertCompletionMessages(String, String, String)
    case removeCompletionMessage(String)
    case removeCompletionMessages(String, String)
    case showCourseCreditMessage(String, String)
    case showAverageCredit(Float)
}

extension Message {
    var messageDescription: String? {
        switch self {
        case .appendStudentMessage:
            return "추가할 학생의 이름을 입력해주세요."
        case .removeStudentMessage:
            return "삭제할 학생의 이름을 입력해주세요."
        case .appendCreditMessage:
            return """
            성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.
            입력 예시) Mickey Swift A+
            만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
            """
        case .removeCreditMessage:
            return """
            성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
            입력 예시) Mickey Swift
            """
        case .peekCreditMessage:
            return "평점을 알고싶은 학생의 이름을 입력해주세요."
        case .mainMessage:
            return """
            원하는 기능을 입력해주세요.
            1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
            """
        case .mainErrorMessage:
            return "뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요."
        case .quitMessage:
            return "프로그램을 종료합니다..."
        case .insertCompletionMessage(let name):
            return "\(name) 학생을 추가했습니다."
        case .insertCompletionMessages(let name, let course, let credit):
            return "\(name) 학생의 \(course) 과목이 \(credit)로 추가(변경) 되었습니다."
        case .removeCompletionMessage(let name):
            return "레코드에서 \(name)을(는) 삭제했습니다."
        case .removeCompletionMessages(let name, let course):
            return "레코드에서 \(name) 학생의 \(course) 가 삭제되었습니다."
        case .showCourseCreditMessage(let course, let credit):
            return "\(course): \(credit)"
        case .showAverageCredit(let average):
            return "평점: \(average)"
        }
    }
}
