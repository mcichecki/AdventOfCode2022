//
//  Day02.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 02/12/2022.
//

import Foundation

struct Day02: Day {
    let dayNumber = 2

    enum Outcome: Int {
        case win = 6
        case draw = 3
        case loss = 0

        init?(outcome: String) {
            switch outcome {
            case "X":
                self = .loss
            case "Y":
                self = .draw
            case "Z":
                self = .win
            default:
                return nil
            }
        }
    }

    enum Shape: Int {
        case rock = 1
        case paper = 2
        case scissors = 3

        init?(oponentShape: String) {
            switch oponentShape {
            case "A":
                self = .rock
            case "B":
                self = .paper
            case "C":
                self = .scissors
            default:
                return nil
            }
        }

        init?(myShape: String) {
            switch myShape {
            case "X":
                self = .rock
            case "Y":
                self = .paper
            case "Z":
                self = .scissors
            default:
                return nil
            }
        }

        var defeats: Shape {
            switch self {
            case .rock:
                return .scissors
            case .paper:
                return .rock
            case .scissors:
                return .paper
            }
        }

        var losesTo: Shape {
            switch self {
            case .rock:
                return .paper
            case .paper:
                return .scissors
            case .scissors:
                return .rock
            }
        }

        func outcome(otherShape: Shape) -> Outcome {
            guard self != otherShape else { return .draw }
            return defeats == otherShape ? .win : .loss
        }

        func shape(for outcome: Outcome) -> Shape {
            switch outcome {
            case .win:
                return losesTo
            case .draw:
                return self
            case .loss:
                return defeats
            }
        }
    }

    func part1() -> Int {
        let start = DispatchTime.now()
        let input = Self.parseInput()

        var sum = 0
        input.forEach {
            guard let opponentShape = Shape(oponentShape: $0[0]),
                  let myShape = Shape(myShape: $0[1])
            else { return }
            let outcome = myShape.outcome(otherShape: opponentShape)
            sum += outcome.rawValue + myShape.rawValue
        }
        return sum
    }

    func part2() -> Int {
        let input = Self.parseInput()

        var sum = 0
        input.forEach {
            guard let opponentShape = Shape(oponentShape: $0[0]),
                  let outcome = Outcome(outcome: $0[1])
            else { return }
            let myShape = opponentShape.shape(for: outcome)
            sum += outcome.rawValue + myShape.rawValue
        }

        return sum
    }
}

extension Day02 {
    private static func parseInput() -> [[String]] {
        InputReader.read(fileName: "day02_1")
            .map { $0.components(separatedBy: " ") }
    }
}
