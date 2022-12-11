//
//  Day11.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 11/12/2022.
//

import Foundation

struct Day11: Day {
    let dayNumber = 11

    func part1() -> Int {
        let input = InputReader.read(fileName: "day11_1")
        let parsedInstructions = parseInput(lines: input)

        var instructions = parsedInstructions
        var inspections: [Int: Int] = [:]
        (0 ..< 20).forEach { round in
            var itemsMap: [Int: [Int]] = [:]
            instructions.forEach { instruction in
                let items = instruction.startingItems + (itemsMap[instruction.identifier] ?? [])
                items.forEach { item in
                    let worryLevel = item.applyOperation(instruction.operation) / 3
                    let nextMonkey = worryLevel.isMultiple(of: instruction.test) ? instruction.ifTrueDest : instruction.ifFalseDest
                    itemsMap[nextMonkey, default: []].append(worryLevel)
                    itemsMap[instruction.identifier, default: []].removeAll(where: { $0 == item  })
                    inspections[instruction.identifier, default: 0] += 1
                }
            }

            instructions = instructions.map {
                var copy = $0
                copy.startingItems = itemsMap[$0.identifier] ?? []
                return copy
            }
        }
        let sortedInspections = inspections.map(\.value).sorted(by: { $0 > $1 })
        return sortedInspections[0] * sortedInspections[1]
    }

    func part2() -> Int {
        let input = InputReader.read(fileName: "day11_1")
        let parsedInstructions = parseInput(lines: input)

        var instructions = parsedInstructions
        var inspections: [Int: Int] = [:]
        let divisor = instructions.map(\.test).reduce(1, *)
        (0 ..< 10000).forEach { round in
            var itemsMap: [Int: [Int]] = [:]
            instructions.forEach { instruction in
                let items = instruction.startingItems + (itemsMap[instruction.identifier] ?? [])
                items.forEach { item in
                    let worryLevel = item.applyOperation(instruction.operation) % divisor
                    let nextMonkey = worryLevel.isMultiple(of: instruction.test) ? instruction.ifTrueDest : instruction.ifFalseDest
                    itemsMap[nextMonkey, default: []].append(worryLevel)
                    itemsMap[instruction.identifier, default: []].removeAll(where: { $0 == item  })
                    inspections[instruction.identifier, default: 0] += 1
                }
            }

            instructions = instructions.map {
                var copy = $0
                copy.startingItems = itemsMap[$0.identifier] ?? []
                return copy
            }
        }
        let sortedInspections = inspections.map(\.value).sorted(by: { $0 > $1 })
        return sortedInspections[0] * sortedInspections[1]
    }
}

extension Day11 {
    enum OperationType: String {
        case multiply = "*"
        case add = "+"
    }
    enum OperationItem {
        case number(Int)
        case old

        func item(for base: Int) -> Int {
            switch self {
            case .number(let number):
                return number
            default:
                return base
            }
        }
    }
    struct Operation {
        let type: OperationType
        let by: OperationItem
    }
    struct MonkeyInstruction {
        let identifier: Int
        var startingItems: [Int]
        let operation: Operation
        let test: Int
        let ifTrueDest: Int
        let ifFalseDest: Int
    }

    private func parseInput(lines: [String]) -> [MonkeyInstruction] {
        var instructions: [MonkeyInstruction] = []
        lines.chunked(into: 6).forEach { groupedLines in
            var identifier: Int {
                guard let match = groupedLines[0].matches(for: "Monkey \\d+").first,
                      let parsedIdentifier = Int(match.split(separator: " ")[1]) else { fatalError() }
                return parsedIdentifier
            }

            var startingItems: [Int] {
                groupedLines[1].matches(for: "\\d+")
                    .compactMap { Int($0) }
            }

            var operation: Operation {
                let operations = groupedLines[2].split(separator: " ").suffix(2)

                guard let rawType = operations.first,
                      let type = OperationType(rawValue: String(rawType))
                else { fatalError() }

                guard let rawItem = operations.last else { fatalError() }
                let operationItem: OperationItem
                if let number = Int(rawItem) {
                    operationItem = .number(number)
                } else {
                    operationItem = .old
                }

                return Operation(type: type, by: operationItem)
            }

            var test: Int {
                guard let last = groupedLines[3].split(separator: " ").last,
                      let test = Int(last) else { fatalError() }
                return test
            }

            var ifTrue: Int {
                guard let raw = groupedLines[4].split(separator: " ").last,
                      let ifTrue = Int(raw) else { fatalError() }
                return ifTrue
            }

            var ifFalse: Int {
                guard let raw = groupedLines[5].split(separator: " ").last,
                      let ifFalse = Int(raw) else { fatalError() }
                return ifFalse
            }

            instructions.append(
                MonkeyInstruction(
                    identifier: identifier,
                    startingItems: startingItems,
                    operation: operation,
                    test: test,
                    ifTrueDest: ifTrue,
                    ifFalseDest: ifFalse
                )
            )
        }
        return instructions
    }
}

extension Int {
    func applyOperation(_ operation: Day11.Operation) -> Int {
        switch operation.type {
        case .add:
            return self + operation.by.item(for: self)
        case .multiply:
            return self * operation.by.item(for: self)
        }
    }
}
