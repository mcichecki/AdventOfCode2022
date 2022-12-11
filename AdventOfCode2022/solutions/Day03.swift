//
//  Day03.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 03/12/2022.
//

import Foundation

struct Day03: Day {
    let dayNumber = 3

    struct Rucksack {
        let firstCompartment: Set<Character>
        let secondCompartment: Set<Character>

        init(items: String) {
            let itemsCount = Int(items.count / 2)
            firstCompartment =  Set(String(items.prefix(itemsCount)))
            secondCompartment = Set(String(items.suffix(itemsCount)))
        }
    }

    struct RucksackGroup {
        let first: Set<Character>
        let second: Set<Character>
        let third: Set<Character>

        init(_ first: String, _ second: String, _ third: String) {
            self.first = Set(first)
            self.second = Set(second)
            self.third = Set(third)
        }
    }

    private let charactersPoints: [Character: Int] = Dictionary(
        uniqueKeysWithValues: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated()
            .map { ($0.element, $0.offset + 1) }
    )

    func part1() -> Int {
        let input = InputReader.read(fileName: "day03_1")
            .map { Rucksack(items: $0) }

        let commonItems = input.compactMap { rucksack in
            rucksack.firstCompartment
                .intersection(rucksack.secondCompartment)
                .first
        }

        return prioritiesSum(commonItems)
    }

    func part2() -> Int {
        let input = InputReader.read(fileName: "day03_1")
            .chunked(into: 3)
            .map { RucksackGroup($0[0], $0[1], $0[2]) }

        let commonItems = input
            .compactMap { rucksack in
                rucksack.first
                    .intersection(rucksack.second)
                    .intersection(rucksack.third)
                    .first
            }

        return prioritiesSum(commonItems)
    }
}

extension Day03 {
    private func prioritiesSum(_ items: [Character]) -> Int {
        items
            .map { charactersPoints[$0] ?? 0 }
            .reduce(0, +)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
