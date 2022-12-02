//
//  Day.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 01/12/2022.
//

import Foundation

enum Part: Int {
    case one = 1
    case two = 2
}

protocol Day {
    var dayNumber: Int { get }

    // TODO: is anwear always Int?
    func part1() -> Int
    func part2() -> Int
}
