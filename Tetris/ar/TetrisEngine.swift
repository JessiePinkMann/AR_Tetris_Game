//
//  TetrisEngine.swift
//  Tetris
//
import Foundation
import ARKit

enum Shapes: Int {
    case O = 0
    case I
    case S
    case Z
    case L
    case J
    case T
}

protocol generateFigureProtocol {
    func generateFigure(_ index: Int) -> Shapes
}

class randomGenerateFigure: generateFigureProtocol{
    func generateFigure(_ index: Int) -> Shapes {
        let a = Int.random(in: 0...6)
        return Shapes(rawValue: a)!
    }
}

class TetrisEngine {

    private let generate: generateFigureProtocol

//    private static let colors = [
//        UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0),
//        UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0),
//        UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0),
//        UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0),
//        UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0),
//        UIColor(red:0.20, green:0.67, blue:0.86, alpha:1.0),
//        UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)]

    private static let colors = [
        UIImage(named: "yellow"),
        UIImage(named: "cyan"),
        UIImage(named: "red"),
        UIImage(named: "blue"),
        UIImage(named: "orange"),
        UIImage(named: "pink"),
        UIImage(named: "green")]


    let boxes: [[SCNNode]]
    var figure: [(Int, Int)]
    var color = UIImage(named: "yellow")
    var speed: Float
    var timer: Timer?
    public var scope : Int = 0 {
        didSet {
            speed -= 0.04
            view.editScore(str: String(scope))
            print("new speed " + String(speed))
        }
    }
    var shap: Shapes
    let view: TetrisView
    var count = 0

    init(_ boxes: [[SCNNode]], view: TetrisView, generate: generateFigureProtocol = randomGenerateFigure()) {
        self.boxes = TetrisEngine.clear(boxes)
        figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
        speed = 2
        shap = Shapes.O
        self.view = view
        self.generate = generate

    }

    static public func clear(_ boxes: [[SCNNode]]) -> [[SCNNode]]{
        for i in boxes{
            for j in i {
                j.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                j.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                j.name = "empty"
            }
        }
        return boxes
    }

    public func shiftToLeft(){
        if figure[0].1 == 0 || figure[2].1 == 0 || figure[1].1 == 0 || figure[3].1 == 0{
            return
        }
        for cordinate in figure {
            if boxes[cordinate.0][cordinate.1 - 1].name == "full" {
                return
            }
        }

        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].1 -= 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }

    public func shiftToRight(){
        if figure[1].1 == 9 || figure[3].1 == 9 || figure[0].1 == 9 || figure[2].1 == 9 {
            return
        }
        for cordinate in figure {
            if boxes[cordinate.0][cordinate.1 + 1].name == "full" {
                return
            }
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].1 += 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }

    public func turn(){

        var a, b, c, d : (Int, Int)
        a = figure[0]
        b = figure[1]
        c = figure[2]
        d = figure[3]
        switch shap {
        case .O:
            print("shap o turn")
        case .I:
            if figure[1].0 ==  figure[2].0 + 1{
                a.0 = b.0
                c.0 = b.0
                c.1 = b.1 + 1
                d.0 = b.0
                d.1 = b.1 + 2
                a.1 = b.1 - 1
            } else {
                a.1 = b.1
                c.1 = b.1
                d.1 = b.1
                a.0 = b.0 + 1
                c.0 = b.0 - 1
                d.0 = b.0 - 2
            }
        case .S:
            if figure[0].1 ==  figure[1].1 - 1{
                b.0 = a.0 + 1
                b.1 = a.1
                d.1 = a.1 + 1
                d.0 = a.0
                c.1 = d.1
                c.0 = d.0 - 1
            } else{
                b.0 = a.0
                b.1 = a.1 + 1
                d.1 = a.1
                d.0 = a.0 - 1
                c.1 = d.1 - 1
                c.0 = d.0
            }
        case .Z:
            if figure[0].1 ==  figure[1].1 - 1{
                a.1 = b.1
                a.0 = b.0 - 1
                c.0 = b.0
                c.1 = b.1 + 1
                d.1 = c.1
                d.0 = c.0 + 1
            } else {
                a.1 = b.1 - 1
                a.0 = b.0
                c.1 = b.1
                c.0 = b.0 - 1
                d.0 = c.0
                d.1 = c.1 + 1
            }
        case .L:
            if figure[0].0 == figure[1].0 + 1 {
                a.0 = b.0
                c.0 = b.0
                a.1 = b.1 - 1
                c.1 = b.1 + 1
                d.1 = c.1
                d.0 = b.0 + 1
            } else if figure[0].0 + 1 == figure[1].0 {
                a.0 = b.0
                a.1 = b.1 + 1
                c.0 = b.0
                c.1 = b.1 - 1
                d.0 = b.0 - 1
            } else if figure[0].1 + 1 == figure[1].1 {
                a.0 = b.0 - 1
                a.1 = b.1
                c.0 = b.0 + 1
                c.1 = b.1
                d.1 = b.1 - 1
            } else {
                a.0 = b.0 + 1
                a.1 = b.1
                c.0 = b.0 - 1
                c.1 = b.1
                d.1 = b.1 + 1
            }
        case .J:
            if figure[0].0 == figure[1].0 + 1 {  // Верхнее состояние
                a.0 = b.0
                a.1 = b.1 - 1
                c.0 = b.0
                c.1 = b.1 + 1
                d.0 = b.0 - 1
                d.1 = b.1 + 1
            } else if figure[0].0 + 1 == figure[1].0 {  // Нижнее состояние
                a.0 = b.0
                a.1 = b.1 + 1
                c.0 = b.0
                c.1 = b.1 - 1
                d.0 = b.0 + 1
                d.1 = b.1 - 1
            } else if figure[0].1 + 1 == figure[1].1 {  // Правое состояние
                a.0 = b.0 - 1
                a.1 = b.1
                c.0 = b.0 + 1
                c.1 = b.1
                d.0 = b.0 + 1
                d.1 = b.1 + 1
            } else {  // Левое состояние
                a.0 = b.0 + 1
                a.1 = b.1
                c.0 = b.0 - 1
                c.1 = b.1
                d.0 = b.0 - 1
                d.1 = b.1 - 1
            }

        case .T:
            if b.0 - 1 == d.0 {
                a.0 = b.0 - 1
                a.1 = b.1
                d.0 = b.0
                d.1 = b.1 + 1
                c.0 = b.0 + 1
                c.1 = b.1
            } else if b.1 + 1 == d.1 {
                a.0 = b.0
                a.1 = b.1 + 1
                d.0 = b.0 + 1
                d.1 = b.1
                c.0 = b.0
                c.1 = b.1 - 1
            } else if b.0 + 1 == d.0 {
                a.0 = b.0 + 1
                a.1 = b.1
                d.0 = b.0
                d.1 = b.1 - 1
                c.0 = b.0 - 1
                c.1 = b.1
            } else {
                a.0 = b.0
                a.1 = b.1 - 1
                d.0 = b.0 - 1
                d.1 = b.1
                c.0 = b.0
                c.1 = b.1 + 1
              }
            
        }
        for i in [a, b, c, d]{
            if i.1 < 0 || i.1 > 9 || i.0 > 20 || i.0 < 0 || boxes[i.0][i.1].name == "full"{
                return
            }
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        figure[0] = a
        figure[1] = b
        figure[2] = c
        figure[3] = d
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
//            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }

    public func shiftDown(){

        timer?.invalidate()
        timer = Timer(timeInterval: 0.02, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
//        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fall), userInfo: nil, repeats: true)
    }

    let semaphore = DispatchSemaphore(value: 1)

    public func start(){
        shap = generate.generateFigure(count)
        count += 1

        switch shap {
        case .O:
            print("OK")
            figure = [(20, 4), (20, 5), (19, 4), (19, 5)]
            color = TetrisEngine.colors[0]
        case .I:
            figure = [(20, 4),(19, 4), (18, 4), (17, 4)]
            color = TetrisEngine.colors[1]
        case .S:
            figure = [(19, 4),(19, 5), (18, 3), (18, 4)]
            color = TetrisEngine.colors[2]
        case .Z:
            figure = [(19, 3),(19, 4), (18, 4), (18, 5)]
            color = TetrisEngine.colors[3]
        case .L: // Г в обратную
            figure = [(20, 4),(19, 4), (18, 4), (18, 5)]
            color = TetrisEngine.colors[4]
        case .J:
            figure = [(20, 4),(19, 4), (18, 4), (18, 3)]
            color = TetrisEngine.colors[5]
        case .T:
            figure = [(20, 4),(20, 5), (20, 6), (19, 5)]
            color = TetrisEngine.colors[6]
        }
        if boxes[figure[0].0][figure[0].1].name == "full" || boxes[figure[1].0][figure[1].1].name == "full" || boxes[figure[2].0][figure[2].1].name == "full" || boxes[figure[3].0][figure[3].1].name == "full"{
            print("Game over")
            print("Scope: " + String(scope))
            view.endGame(scope: scope)
            return
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(fall), userInfo: nil, repeats: true)

//        RunLoop.main.add(timer!, forMode: .common)
        print("test")

    }

    func deleteRow(){
        var i = 1
        while i <= 20 {
//        for i in 1...20{
            var flag = true
            for j in 0...9{
                if (boxes[i][j].name != "full") {
                    flag = false
                    break
                }
            }
            if flag {
                scope += 1
                for j in i...19{
                    for k in 0...9{
                        if boxes[j+1][k].name == "full"{
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = TetrisEngine.colors[Int.random(in: 0...6)]
                            boxes[j][k].name = "full"
                        } else {
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
                            boxes[j][k].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                            boxes[j][k].name = "empty"
                        }
                    }

                }
                i -= 1
            }
            i += 1
        }
    }


    @objc func fall(timer: Timer){
        print("Timer")
        for cordinate in figure {
            if (cordinate.0 - 1 == 0 || boxes[cordinate.0 - 1][cordinate.1].name == "full"){
                timer.invalidate()
                print("new")
                for cor in figure {
                    boxes[cor.0][cor.1].name = "full"
                }
                deleteRow()
                start()
                return
            }
        }

        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
        }
        for i in 0..<4 {
            figure[i].0 -= 1
        }
        for cordinate in figure {
            boxes[cordinate.0][cordinate.1].geometry?.firstMaterial?.diffuse.contents = color
            print(String(cordinate.0) + ":" + String(cordinate.1) + " draw")
        }
    }

}
