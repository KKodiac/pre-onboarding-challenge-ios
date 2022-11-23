//
//  main.swift
//  MyCreditManager
//
//  Created by Sean Hong on 2022/11/22.
//

import Foundation

protocol CreditManager {
    var creditRecord: [String: [String: String]] { get set }
    func appendStudent()
    func removeStudent()
    func appendCredit()
    func removeCredit()
    func peekCredit()
    func mainLoop()
    func quit()
}

class MyCreditManager: CreditManager {
    var creditRecord: [String: [String: String]] = [:]
    let creditToGPA: [String: Float] = ["A+": 4.5, "A": 4.0, "B+": 3.5, "B": 3.0, "C+": 2.5, "C": 2.0, "D+": 1.5, "D": 1.0, "F": 0.0]
    
    func appendStudent() {
        print("추가할 학생의 이름을 입력해주세요.")
        guard let studentName = readLine() else { return }
        append(studentName)
    }
    
    func removeStudent() {
        print("삭제할 학생의 이름을 입력해주세요.")
        guard let studentName = readLine() else { return }
        remove(studentName)
    }
    
    func appendCredit() {
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력 예시) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        guard let data = readLine() else { return }
        let appendData = data.split(separator: " ").map{ String($0) }
        append(data: appendData)
    }
    
    func removeCredit() {
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력 예시) Mickey Swift")
        guard let data = readLine() else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        }
        let removeData = data.split(separator: " ").map{ String($0) }
        let studentName = removeData[0]
        let course = removeData[1]
        
        remove(name: studentName, course: course)
    }
    
    func peekCredit() {
        print("평점을 알고싶은 학생의 이름을 입력해주세요.")
        guard let studentName = readLine() else { return }
        peek(studentName)
    }
    
    
    func mainLoop() {
        while true {
            print("원하는 기능을 입력해주세요.")
            print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
            guard let actionInput = readLine() else { continue }
            switch actionInput {
            case "1":
                self.appendStudent()
            case "2":
                self.removeStudent()
            case "3":
                self.appendCredit()
            case "4":
                self.removeCredit()
            case "5":
                self.peekCredit()
            case "X":
                self.quit()
            default:
                print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            }
        }
    }
    
    func quit() {
        print("프로그램을 종료합니다...")
        exit(0)
    }
    
    
    // MARK: Private Functions
    
    /* 학생추가
     - 메뉴를 선택한 후에도 잘못 입력한 것이 있으면 처리해 주어야합니다.
     - 이미 존재하는 학생은 다시 추가하지 않습니다. */
    private func append(_ name: String) {
        do {
            let name = try validateStudentName(name: name)
            try insertNewNameToRecord(name: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* 성적추가
     - 메뉴를 선택한 후에도 잘못 입력한 것이 있으면 처리해 주어야합니다.
     - 없는 학생의 성적은 추가하지 않습니다. */
    private func append(data: [String]) {
        do {
            if data.count < 3 { throw Error.notEnoughInput }
            let name = try validateStudentName(name: data[0])
            let course = try validateCourseName(course: data[1])
            let credit = try validateCredit(credit: data[2])
            try insertCourseAndCreditToRecord(by: name, course: course, credit: credit)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /* 학생삭제
     - 메뉴를 선택한 후에도 잘못 입력한 것이 있으면 처리해 주어야합니다.
     - 없는 학생은 삭제하지 않습니다. */
    private func remove(_ name: String) {
        do {
            let name = try validateStudentName(name: name)
            try removeStudentFromRecord(name: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* 성적삭제
     - 메뉴를 선택한 후에도 잘못 입력한 것이 있으면 처리해 주어야합니다.
     - 없는 학생의 성적은 삭제하지 않습니다. */
    private func remove(name: String, course: String) {
        do {
            let name = try validateStudentName(name: name)
            let course = try validateCourseName(course: course)
            try removeCourseFromRecord(name: name, course: course)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* 평점보기
     - 메뉴를 선택한 후에도 잘못 입력한 것이 있으면 처리해 주어야합니다.
     - 해당 학생의 과목과 성적을 모두 출력한 후 마지막 줄에 평점을 출력합니다.
     - 없는 학생은 평점을 보여주지 않습니다. */
    private func peek(_ name: String) {
        do {
            let name = try validateStudentName(name: name)
            try showAllCourses(by: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Private Helper Functions
    
    private func validateStudentName(name: String) throws -> String{
        if name.count == 0 {
            throw Error.invalidNameEmpty
        } else {
            for character in name {
                if !("a"..."z" ~= character) && !("A"..."Z" ~= character) {
                    throw Error.invalidName(name)
                }
            }
        }
        return name
    }
    
    private func validateCourseName(course: String) throws -> String{
        for character in course {
            if !(" "..."~" ~= character) {
                throw Error.invalidCourse(course)
            }
        }
        return course
    }
    
    private func validateCredit(credit: String) throws -> String{
        if (creditToGPA[credit] == nil) {
            throw Error.invalidCredit(credit)
        }
        return credit
    }
    
    
    private func insertNewNameToRecord(name: String) throws {
        if creditRecord.contains(where: { $0.key == name }) {
            throw Error.nameRecordExists(name)
        } else {
            creditRecord[name] = [:]
            print("\(name) 학생을 추가했습니다.")
        }
    }
    
    private func insertCourseAndCreditToRecord(by name: String, course: String, credit: String) throws {
        if creditRecord[name] != nil {
            creditRecord[name]![course] = credit
            print("\(name) 학생의 \(course) 과목이 \(credit)로 추가(변경) 되었습니다.")
        } else {
            throw Error.nameRecordNotFound(name)
        }
    }
    
    private func removeCourseFromRecord(name: String, course: String) throws {
        if creditRecord[name] != nil {
            if creditRecord[name]![course] != nil {
                creditRecord[name]!.removeValue(forKey: course)
            } else {
                throw Error.courseRecordNotFound(name, course)
            }
        } else {
            throw Error.nameRecordNotFound(name)
        }
    }
    
    private func removeStudentFromRecord(name: String) throws {
        if creditRecord[name] != nil {
            creditRecord.removeValue(forKey: name)
            print("레코드에서 \(name)을(는) 삭제했습니다.")
        } else {
            throw Error.nameRecordNotFound(name)
        }
    }
    
    private func showAllCourses(by name: String) throws {
        if let courses = creditRecord[name] {
            for (course,credit) in courses {
                print("\(course): \(credit)")
            }
            let average = calculateAverageCredit(with: courses)
            print("평점: \(average)")
        } else {
            throw Error.nameRecordNotFound(name)
        }
    }
    
    private func calculateAverageCredit(with courses: [String: String]) -> Float {
        var totalGPA: Float = 0
        for (_, credit) in courses {
            let gpa = creditToGPA[credit]!
            totalGPA += gpa
        }
        return totalGPA / Float(courses.count)
    }
    
}

let main = MyCreditManager()
main.mainLoop()
