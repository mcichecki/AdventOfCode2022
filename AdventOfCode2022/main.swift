//
//  main.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 01/12/2022.
//

import Foundation

import Foundation

let days: [any Day] = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08()
]

days.forEach { day in
    print("Day #\(day.dayNumber)")
    Benchmark.execute(part: .one) { day.part1() }
    Benchmark.execute(part: .two) { day.part2() }
}
