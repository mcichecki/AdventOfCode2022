//
//  Day05.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 05/12/2022.
//

import Foundation

struct Day05: Day {
    let dayNumber = 5

    struct Command {
        let count: Int
        let from: Int
        let to: Int
    }

    func part1() -> String {
        let parsed = parsedInput()
        var commands: [Command] = parsed.0
        var crates: [Int: [String]] = parsed.1

        commands.forEach { command in
            (0 ..< command.count).forEach { _ in
                let removed = crates[command.from, default: []].removeLast()
                crates[command.to, default: []].append(removed)
            }
        }

        return crates.sorted(by: { $0.key < $1.key }).compactMap(\.value.last).joined()
    }

    func part2() -> String {
        let parsed = parsedInput()
        var commands: [Command] = parsed.0
        var crates: [Int: [String]] = parsed.1

        commands.forEach { command in
            let siema = crates[command.from, default: []].suffix(command.count)
            crates[command.from] = crates[command.from, default: []].dropLast(command.count)
            crates[command.to, default: []].append(contentsOf: siema)
        }

        return crates.sorted(by: { $0.key < $1.key }).compactMap(\.value.last).joined()
    }
}

extension Day05 {
    private func parsedInput() -> ([Command], [Int: [String]]) {
        var commands: [Command] = []
        var crates: [Int: [String]] = [:]
        InputReader.read(fileName: "day05_1", removeEmptyLines: false)
            .forEach { line in
                let numberMatches = line.matches(for: "\\d+").compactMap { Int($0) }
                if !numberMatches.isEmpty && line.contains("m") {
                    commands.append(
                        Command(count: numberMatches[0], from: numberMatches[1] - 1, to: numberMatches[2] - 1)
                    )
                    return
                }

                let regex = try! NSRegularExpression(pattern: "[A-Z]")
                let matches = regex.matches(in: line, range: NSRange(line.startIndex..., in: line))
                matches
                    .forEach {
                        let newElement = String(line[Range($0.range, in: line)!])
                        crates[Int($0.range.location / 4), default: []].insert(newElement, at: 0)
                    }
            }
        return (commands, crates)
    }
}
