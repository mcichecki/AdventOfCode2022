//
//  Day01.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 01/12/2022.
//

import Foundation

struct Day01: Day {
    let dayNumber = 1

    func part1() -> Int {
        let calories = InputReader.read(fileName: "day01_1", removeEmptyLines: false)
            .map(Int.init)

        var maxSum: Int = 0
        var caloriesSum = 0
        for calorie in calories {
            if let calorie {
                caloriesSum += calorie
            } else {
                maxSum = max(caloriesSum, maxSum)
                caloriesSum = 0
            }
        }

        return maxSum
    }

    func part2() -> Int {
        let calories = InputReader.read(fileName: "day01_1", removeEmptyLines: false)
            .map(Int.init)

        var caloriesSum = 0
        var sums: [Int] = []
        for calorie in calories {
            if let calorie {
                caloriesSum += calorie
            } else {
                sums.append(caloriesSum)
                caloriesSum = 0
            }
        }

        return sums.sorted().suffix(3).reduce(0, +)
    }
}
