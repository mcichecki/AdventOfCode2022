//
//  Day07.swift
//  AdventOfCode2022
//
//  Created by Michal Cichecki on 07/12/2022.
//

import Foundation

struct Day07: Day {
    let dayNumber = 7

    enum Command {
        case cd(String)
        case ls

        init?(line: String) {
            guard line.first == "$" else { return nil }
            var copy = line
            copy.removeFirst(2)
            if copy.starts(with: "ls") {
                self = .ls
            } else if copy.starts(with: "cd") {
                self = .cd(line.last(startingFromIndex: 5))
            } else {
                return nil
            }
        }
    }

    class FilesMap {
        var files: [File] = []
        var dirs: [Dir] = []
    }

    class Dir {
        let name: String
        let parent: Dir?
        var dirs: [Dir] = []
        var files: [File] = []

        var allDirs: [Dir] {
            return dirs + dirs.flatMap { $0.allDirs }
        }

        init(name: String, parent: Dir?) {
            self.name = name
            self.parent = parent
        }

        func getSize(val: Int = 0) -> Int {
            let fileSize = files.map(\.size).reduce(0, +)
            guard !dirs.isEmpty else { return fileSize + val }
            let dirSize = dirs.map { $0.getSize(val: val) }.reduce(0, +)
            return fileSize + dirSize
        }
    }

    class File {
        let name: String
        let size: Int

        init(name: String, size: Int) {
            self.name = name
            self.size = size
        }
    }

    func part1() -> Int {
        let input = InputReader.read(fileName: "day07_1")
        guard let rootDir = getRootDir(terminalOutput: input) else { return 0 }

        let maxSize = 100_000
        var totalSize = 0
        rootDir.allDirs.forEach {
            let size = $0.getSize()
            guard size < maxSize else { return }
            totalSize += size
        }
        return totalSize
    }

    func part2() -> Int {
        let input = InputReader.read(fileName: "day07_1")
        guard let rootDir = getRootDir(terminalOutput: input) else { return 0 }

        let available = 70_000_000
        let unused = 30_000_000
        let size = rootDir.getSize()
        let currentUnused = available - size

        var minDirSize = currentUnused
        rootDir.allDirs
            .forEach {
                let size = $0.getSize()
                guard currentUnused + size > unused else { return }
                minDirSize = min(minDirSize, size)
            }
        return minDirSize
    }
}

extension Day07 {
    private func getRootDir(terminalOutput: [String]) -> Dir? {
        var rootDir: Dir?
        var currentDir: Dir?
        
        terminalOutput.forEach { line in
            if let command = Command(line: line) {
                switch command {
                case .cd(let commandName):
                    if commandName == ".." {
                        currentDir = currentDir?.parent
                    } else if commandName == "/" {
                        rootDir = Dir(name: commandName, parent: nil)
                        currentDir = rootDir
                    } else {
                        currentDir = currentDir?.dirs.first(where: { $0.name == commandName })
                    }
                case .ls:
                    return
                }
            }

            let components = line.split(separator: " ")
            let name = String(components[1])
            if let fileSize = Int(components[0]) {
                currentDir?.files.append(File(name: name, size: fileSize))
            } else {
                currentDir?.dirs.append(Dir(name: name, parent: currentDir))
            }
        }

        return rootDir
    }
}

extension String {
    fileprivate func last(startingFromIndex i: Int) -> String {
        String(self[index(startIndex, offsetBy: i)...])
    }
}
