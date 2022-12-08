//
//  Day08.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 08/12/2022.
//

import Foundation

struct Day08: Day {
    let dayNumber = 8

    func part1() -> Int {
        let input = InputReader.read(fileName: "day08_1")
            .map { $0.compactMap { Int(String($0)) } }

        let columnsCount = input.count
        let rowsCount = input[0].count
        let outerTreesCount = rowsCount * 2 + (columnsCount - 2) * 2

        var visibleTreesCount = 0
        for (row, heights) in input.enumerated() {
            for (column, height) in heights.enumerated() {
                switch (row, column) {
                case (0, _), (_, 0), (_, columnsCount - 1), (rowsCount - 1, _):
                    continue
                default:
                    let columnHeights = input.map { $0[column] }

                    var leftHeights: Array<Int>.SubSequence { heights[..<column] }
                    var rightHeights: Array<Int>.SubSequence { heights[(column + 1)...] }
                    var topHeights: Array<Int>.SubSequence { columnHeights[..<row] }
                    var bottomHeights: Array<Int>.SubSequence { columnHeights[(row + 1)...] }

                    if leftHeights.allSatisfy({ $0 < height }) {
                        visibleTreesCount += 1
                    } else if rightHeights.allSatisfy({ $0 < height }) {
                        visibleTreesCount += 1
                    } else if topHeights.allSatisfy({ $0 < height }) {
                        visibleTreesCount += 1
                    } else if bottomHeights.allSatisfy({ $0 < height }) {
                        visibleTreesCount += 1
                    }
                }
            }
        }

        return outerTreesCount + visibleTreesCount
    }

    func part2() -> Int {
        let input = InputReader.read(fileName: "day08_1")
            .map { $0.compactMap { Int(String($0)) } }

        let columnsCount = input.count
        let rowsCount = input[0].count

        var maxHeight = 0
        for (row, heights) in input.enumerated() {
            for (column, height) in heights.enumerated() {
                switch (row, column) {
                case (0, _), (_, 0), (_, columnsCount - 1), (rowsCount - 1, _):
                    continue
                default:
                    let columnHeights = input.map { $0[column] }

                    let leftHeights = heights[..<column]
                    let rightHeights = heights[(column + 1)...]
                    let topHeights = columnHeights[..<row]
                    let bottomHeights = columnHeights[(row + 1)...]

                    var treesCount = 1
                    treesCount *= (
                        leftHeights.reversed().enumerated().first(where: { $0.1 >= height })?.offset ?? leftHeights.count - 1
                    ) + 1
                    treesCount *= (
                        topHeights.reversed().enumerated().first(where: { $0.1 >= height })?.offset ?? topHeights.count - 1
                    ) + 1
                    treesCount *= (
                        rightHeights.enumerated().first(where: { $0.1 >= height })?.offset ?? rightHeights.count - 1
                    ) + 1
                    treesCount *= (
                        bottomHeights.enumerated().first(where: { $0.1 >= height })?.offset ?? bottomHeights.count - 1
                    ) + 1
                    maxHeight = max(treesCount, maxHeight)
                }
            }
        }

        return maxHeight
    }
}
