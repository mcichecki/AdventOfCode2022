//
//  Day06.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 06/12/2022.
//

import Foundation

struct Day06: Day {
    let dayNumber = 6

    func part1() -> Int {
        guard let input = InputReader.read(fileName: "day06_1").first else { return 0 }
        return findMarker(datastream: input, distinctCharCount: 4)
    }

    func part2() -> Int {
        guard let input = InputReader.read(fileName: "day06_1").first else { return 0 }

        return findMarker(datastream: input, distinctCharCount: 14)
    }
}

extension Day06 {
    private func findMarker(
        datastream: String,
        distinctCharCount threshold: Int
    ) -> Int {
        var processedBuffer: [Character] = []
        var count: Int = 0
        for character in datastream {
            processedBuffer.append(character)
            guard processedBuffer.count >= threshold else { continue }
            let lastFour = Array(processedBuffer.suffix(threshold))
            if Set(lastFour).count == lastFour.count {
                count = processedBuffer.count
                break
            }
        }
        return count
    }
}
