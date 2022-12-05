//
//  Day04.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 04/12/2022.
//

import Foundation

struct Day04: Day {
    let dayNumber = 4

    func part1() -> Int {
        let input = InputReader.read(fileName: "day04_1")
            .map { line -> [Int] in line.matches(for: "\\d+").compactMap { Int($0) } }
            .map { (Range($0[0] ... $0[1]), Range($0[2] ... $0[3])) }

        let containedRanges = input
            .filter { $0 ~= $1 || $1 ~= $0 }

        return containedRanges.count
    }

    func part2() -> Int {
        let input = InputReader.read(fileName: "day04_1")
            .map { line -> [Int] in line.matches(for: "\\d+").compactMap { Int($0) } }
            .map { (Range($0[0] ... $0[1]), Range($0[2] ... $0[3])) }

        let containedRanges = input
            .filter { $0.overlaps($1) || $1.overlaps($0) }

        return containedRanges.count
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(
                in: self,
                range: NSRange(self.startIndex..., in: self)
            )
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension Range {
    fileprivate static func ~=(lhs: Self, rhs: Self) -> Bool {
        rhs.clamped(to: lhs) == rhs
    }
}
