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

enum ActionInput: String {
    case appendStudentActionInput = "1"
    case removeStudentActionInput = "2"
    case appendCreditActionInput = "3"
    case removeCreditActionInput = "4"
    case peekActionInput = "5"
    case quitActionInput = "X"
}

extension String {
    var isAlphabet: Bool {
        return range(of: "[a-zA-Z]", options: .regularExpression) != nil
    }
}

class MyCreditManager: CreditManager {
    var creditRecord: [String: [String: String]] = [:]
    let creditToGPA: [String: Float] = ["A+": 4.5, "A": 4.0, "B+": 3.5, "B": 3.0, "C+": 2.5, "C": 2.0, "D+": 1.5, "D": 1.0, "F": 0.0]
    
    func appendStudent() {
        print(Message.appendStudentMessage.messageDescription!)
        guard let studentName = readLine() else { return }
        append(studentName)
    }
    
    func removeStudent() {
        print(Message.removeStudentMessage.messageDescription!)
        guard let studentName = readLine() else { return }
        remove(studentName)
    }
    
    func appendCredit() {
        print(Message.appendCreditMessage.messageDescription!)
        guard let data = readLine() else { return }
        let appendData = data.split(separator: " ").map{ String($0) }
        append(appendData)
    }
    
    func removeCredit() {
        print(Message.removeCreditMessage.messageDescription!)
        guard let data = readLine() else { return }
        let removeData = data.split(separator: " ").map{ String($0) }
        remove(removeData)
    }
    
    func peekCredit() {
        print(Message.peekCreditMessage.messageDescription!)
        guard let studentName = readLine() else { return }
        peek(studentName)
    }
    
    
    func mainLoop() {
        while true {
            print(Message.mainMessage.messageDescription!)
            if let rawInput = readLine() {
                let actionInput = ActionInput(rawValue: rawInput)
                switch actionInput {
                case .appendStudentActionInput :
                    self.appendStudent()
                case .removeStudentActionInput:
                    self.removeStudent()
                case .appendCreditActionInput:
                    self.appendCredit()
                case .removeCreditActionInput:
                    self.removeCredit()
                case .peekActionInput:
                    self.peekCredit()
                case .quitActionInput:
                    self.quit()
                default:
                    print(Message.mainErrorMessage.messageDescription!)
                }
            } else { continue }
        }
    }
    
    func quit() {
        print(Message.quitMessage.messageDescription!)
        exit(0)
    }
    
    
    // MARK: Private Functions
    
    /* ????????????
     - ????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ??????????????????.
     - ?????? ???????????? ????????? ?????? ???????????? ????????????. */
    private func append(_ name: String) {
        do {
            let name = try validateStudentName(name)
            try insertRecord(with: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* ????????????
     - ????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ??????????????????.
     - ?????? ????????? ????????? ???????????? ????????????. */
    private func append(_ data: [String]) {
        do {
            if data.count < 3 { throw Error.notEnoughInput }
            let name = try validateStudentName(data[0])
            let course = try validateCourseName(data[1])
            let credit = try validateCreditName(data[2])
            try insertRecord(with: name, course, credit)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /* ????????????
     - ????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ??????????????????.
     - ?????? ????????? ???????????? ????????????. */
    private func remove(_ name: String) {
        do {
            let name = try validateStudentName(name)
            try removeRecord(with: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* ????????????
     - ????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ??????????????????.
     - ?????? ????????? ????????? ???????????? ????????????. */
    private func remove(_ data: [String]) {
        do {
            if data.count < 2 { throw Error.notEnoughInput }
            let name = try validateStudentName(data[0])
            let course = try validateCourseName(data[1])
            try removeRecord(with: name, course)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* ????????????
     - ????????? ????????? ????????? ?????? ????????? ?????? ????????? ????????? ??????????????????.
     - ?????? ????????? ????????? ????????? ?????? ????????? ??? ????????? ?????? ????????? ???????????????.
     - ?????? ????????? ????????? ???????????? ????????????. */
    private func peek(_ name: String) {
        do {
            let name = try validateStudentName(name)
            try showAllCourses(by: name)
        } catch let error as Error {
            print(error.errorDescription!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Private Helper Functions
    
    private func validateStudentName(_ name: String) throws -> String {
        if name.isEmpty || !name.isAlphabet {
            throw Error.invalidName
        }
        return name
    }
    
    private func validateCourseName(_ course: String) throws -> String {
        if course.isEmpty || !course.isAlphabet {
            throw Error.invalidCourse(course)
        }
        return course
    }
    
    private func validateCreditName(_ credit: String) throws -> String {
        if creditToGPA[credit] == nil {
            throw Error.invalidCredit(credit)
        }
        return credit
    }
    
    private func insertRecord(with name: String) throws {
        if isValidRecord(name) {
            throw Error.nameRecordExists(name)
        }
        creditRecord[name] = [:]
        print(Message.insertCompletionMessage(name).messageDescription!)
    }
    
    private func insertRecord(with name: String, _ course: String, _ credit: String) throws {
        if !isValidRecord(name) {
            throw Error.recordNotFound
        }
        creditRecord[name]![course] = credit
        print(Message.insertCompletionMessages(name, course, credit).messageDescription!)
    }
    
    
    private func removeRecord(with name: String, _ course: String) throws {
        if !isValidRecord(name, course) {
            throw Error.recordNotFound
        }
        creditRecord[name]!.removeValue(forKey: course)
        print(Message.removeCompletionMessages(name, course).messageDescription!)
    }
    
    
    private func removeRecord(with name: String) throws {
        if !isValidRecord(name) {
            throw Error.recordNotFound
        }
        creditRecord.removeValue(forKey: name)
        print(Message.removeCompletionMessage(name).messageDescription!)
    }
    
    private func showAllCourses(by name: String) throws {
        if let courses = creditRecord[name] {
            for (course,credit) in courses {
                print(Message.showCourseCreditMessage(course, credit).messageDescription!)
            }
            let average = calculateAverageCredit(with: courses)
            print(Message.showAverageCredit(average).messageDescription!)
        } else {
            throw Error.recordNotFound
        }
    }
    
    private func calculateAverageCredit(with courses: [String: String]) -> Float {
        var totalGPA: Float = 0
        if courses.count == 0 { return 0.0 }
        for (_, credit) in courses {
            let gpa = creditToGPA[credit]!
            totalGPA += gpa
        }
        return totalGPA / Float(courses.count)
    }
    
    private func isValidRecord(_ key: String) -> Bool {
        return creditRecord.contains(where: { $0.key == key })
    }
    
    private func isValidRecord(_ name: String, _ course: String) -> Bool {
        guard let nameRecord = creditRecord[name] else { return false }
        return nameRecord.contains(where: { $0.key == course })
    }
}

let main = MyCreditManager()
main.mainLoop()
