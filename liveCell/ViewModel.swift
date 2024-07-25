//
//  ViewModel.swift
//  liveCell
//
//  Created by Diana Tsarkova on 22.07.2024.
//

import Foundation
import UIKit.UIImage

/* 
 Создавая новый мир, он наполняет его клетками. Каждый раз, нажимая на кнопку в приложении, в список клеток добавляется новая:

 — равновероятно она может быть как живой, так и мёртвой;

 — жизнь зарождается, если до этого трижды подряд создалась живая клетка;

 — если трижды подряд родилась мёртвая клетка, жизнь рядом умирает.

 Изначально список клеток пуст.
 */

enum CellType: Int {
    case dead
    case alive
    case life

    var model: CellModel {
        switch self {
        case .dead:
            return CellModel(icon: "💀", title: "Мертвая", description: "или прикидывается")
        case .alive:
            return CellModel(icon: "💥", title: "Живая", description: "и шевелится!")
        case .life:
            return CellModel(icon: "🐣", title: "Жизнь", description: "Ку-ку!")
        }
    }
}

struct CellModel {
    let icon: String
    let title: String
    let description: String
}

class ViewModel {

    var updateHandler: (() -> Void)?

    var cells: [CellType] = []

    private var firstLifeIndex: Int?
    private var lastThreeType: CellType?
    private var threeTypeCount: Int = 0
    private var lastType: CellType?

    // в список клеток добавляется новая
    func addCell() {
        defer {
            updateHandler?()
        }
        
        // — равновероятно она может быть как живой, так и мёртвой;
        var newCellType = CellType(rawValue: Int.random(in: 0...1)) ?? .dead

        if let lastThreeType = lastThreeType {
            // жизнь зарождается, если до этого трижды подряд создалась живая клетка
            if lastThreeType == .alive {
                newCellType = .life
                self.firstLifeIndex = cells.count
                cells.append(newCellType)
                self.lastThreeType = nil
                threeTypeCount = 0
                lastType = newCellType
                return
            // если трижды подряд родилась мёртвая клетка, жизнь рядом умирает
            } else if let firstLifeIndex = firstLifeIndex, lastThreeType == .dead {
                print("CELL NUMBER \(firstLifeIndex) IS DEAD ")
                cells[firstLifeIndex] = .dead
                self.firstLifeIndex = nil
            }
        }
        cells.append(newCellType)
        if let type = lastType, newCellType == type {
            threeTypeCount += 1
            if threeTypeCount == 3 {
                lastThreeType = lastType
            }
        } else {
            if lastType != nil && lastType != .life {
                firstLifeIndex = nil
            }
            threeTypeCount = 1
            lastThreeType = nil
        }
        lastType = newCellType
    }

}
