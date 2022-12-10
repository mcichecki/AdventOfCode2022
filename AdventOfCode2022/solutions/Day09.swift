//
//  Day09.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 09/12/2022.
//

import Foundation

struct Day10: Day {
    let dayNumber = 10

    enum Instruction {
        case addx(Int)
        case noop

        var cyclesCount: Int {
            switch self {
            case .addx:
                return 2
            case .noop:
                return 1
            }
        }

        init(line: String) {
            let matchedValues = line.matches(for: "-?[0-9]+").compactMap { Int($0) }
            if let matchedValue = matchedValues.first {
                self = .addx(matchedValue)
            } else {
                self = .noop
            }
        }
    }

    func part1() -> Int {
        let input = InputReader.read(fileName: "day10_1")
            .map { Instruction(line: $0) }

        var valueX = 1
        var cycle = 0
        var cyclesSet = Set([20, 60, 100, 140, 180, 220])
        var sum = 0
        input.forEach { instruction in
            switch instruction {
            case .addx(let value):
                (0 ..< instruction.cyclesCount).forEach {
                    cycle += 1
                    if cyclesSet.contains(cycle) {
                        sum += cycle * valueX
                    }
                    valueX += $0 * value
                }
            case .noop:
                cycle += 1
                if cyclesSet.contains(cycle) {
                    sum += cycle * valueX
                }
            }
        }

        return sum
    }

    // if the current cycle == register +- 1 draw a # else .

    func part2() -> Int {
        let input = InputReader.read(fileName: "day10_1")
            .map { Instruction(line: $0) }

        var valueX = 1
        var cycle = 0
        var pixels: [[Character]] = Array(repeating: Array<Character>(), count: 6)
        input.forEach { instruction in
            switch instruction {
            case .addx(let value):
                (0 ..< instruction.cyclesCount).forEach {
                    cycle += 1
                    let currentLine = Int((cycle - 1) / 40)
                    let newPixel: Character = (valueX ... valueX + 2).contains(cycle - (currentLine * 40)) ? "#" : "."
                    pixels[currentLine].append(newPixel)
                    valueX += $0 * value
                }
            case .noop:
                cycle += 1
                let currentLine = Int((cycle - 1) / 40)
                let newPixel: Character = (valueX ... valueX + 2).contains(cycle - (currentLine * 40)) ? "#" : "."
                pixels[currentLine].append(newPixel)
            }
        }

        pixels.forEach { print(String($0)) }
        return 0
    }
}
