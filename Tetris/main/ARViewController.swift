//
//  ARViewController.swift
//  Tetris
//
import UIKit
import SceneKit
import ARKit
import SwiftUI

class ARViewController: UIViewController {
    // the size of the field depends (inversely proportional)
    let koef: Float = 20

    // array with cubes
    var arr : [[SCNNode]] = [[]]

    // Game Engine
    var tetris: TetrisEngine?

    // Configuration for plane search
    let configuration: ARWorldTrackingConfiguration = {
        let controll = ARWorldTrackingConfiguration()
        controll.planeDetection = .horizontal
        return controll
    }()

    // Shows score
    let scoreLabel : UILabel = {
        let control = UILabel()
        control.textColor = .white
        control.font = control.font.withSize(40)
        control.text = String(0)
        return control
    }()

    // Label Game Over
    let gameOverLabel: UILabel = {
        let control = UILabel()
        control.numberOfLines = 0
        control.font = control.font.withSize(70)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()


     weak var sceneView: ARSCNView? = {
        let sceneView = ARSCNView()
//        sceneView.delegate = self
        return sceneView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView!)
        sceneView!.frame = view.frame
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        ConfigSwipes()

        // Set the view's delegate
        sceneView?.delegate = self

        ConfigScoreLabel()
        
        // Add info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showInfoView), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }

    func createFloorNode(anchor: ARPlaneAnchor) -> [SCNNode]{
        var a : [SCNNode] = []
        var height: Float = 0
        var countHeight = 0
        while countHeight < 20 {
            var row : [SCNNode] = []
            countHeight += 1
            var length = anchor.center.x - ((Float(CGFloat(anchor.extent.x))/koef)*5)
            var count  = 0
            while count < 10{
                count += 1
                let size = CGFloat(anchor.extent.x)/CGFloat(koef)
                let geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
                let floorNode = SCNNode(geometry: geometry)
                floorNode.position = SCNVector3(x: length, y: height, z: anchor.center.z)
                floorNode.geometry?.firstMaterial?.isDoubleSided = true
                floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box")
                floorNode.geometry?.firstMaterial?.isDoubleSided = true
                floorNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
                floorNode.name = "Plane"
                a.append(floorNode)
                row.append(floorNode)
                length += Float(CGFloat(anchor.extent.x))/koef
            }
            arr.append(row)
            height += Float(CGFloat(anchor.extent.x))/koef
        }
        return a
    }

    // MARK: - Swipes

    fileprivate func ConfigSwipes() {
        let swipeRight  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToRight))
        let swipeLeft  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToLeft))
        let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToDown))
        let swipeUp  = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToUp))
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))

        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        sceneView?.addGestureRecognizer(gesture)
        sceneView?.addGestureRecognizer(swipeRight)
        sceneView?.addGestureRecognizer(swipeLeft)
        sceneView?.addGestureRecognizer(swipeDown)
        sceneView?.addGestureRecognizer(swipeUp)
    }

    @objc func swipeToRight(sender: UISwipeGestureRecognizer){
        print("right")
        tetris?.shiftToRight()
    }

    @objc func swipeToLeft(sender: UISwipeGestureRecognizer){
        print("left")
        tetris?.shiftToLeft()
    }

    @objc func swipeToDown(sender: UISwipeGestureRecognizer){
        print("down")
        tetris?.shiftDown()
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
        print("touch")
        if tetris != nil || arr == [[]] {
            return
        }
        scoreLabel.text = "0"
        gameOverLabel.removeFromSuperview()
        tetris = TetrisEngine(arr, view: self)
        tetris?.start()
    }

    @objc func swipeToUp(sender: UISwipeGestureRecognizer){
        print("up")
        tetris?.turn()
    }

    // MARK: - Config label

    fileprivate func ConfigScoreLabel() {
        let backgrond = UIView()
        backgrond.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        sceneView?.addSubview(backgrond)
        backgrond.translatesAutoresizingMaskIntoConstraints = false
        backgrond.topAnchor.constraint(equalTo: sceneView!.topAnchor, constant: 40).isActive = true
        backgrond.leftAnchor.constraint(equalTo: sceneView!.leftAnchor, constant: 10).isActive = true
        backgrond.heightAnchor.constraint(equalToConstant: 100).isActive = true
        backgrond.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backgrond.layer.cornerRadius = 5
        backgrond.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: backgrond.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: backgrond.centerYAnchor).isActive = true
    }

    func configExit() {
        let cancel = UIButton(type: .close)
//        cancel.setTitle("X", for: .normal)
//        cancel.backgroundColor = .yellow
        cancel.addTarget(self, action: #selector(exit), for: .touchUpInside)
        sceneView?.addSubview(cancel)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.topAnchor.constraint(equalTo: sceneView!.topAnchor, constant: 40).isActive = true
        cancel.rightAnchor.constraint(equalTo: sceneView!.rightAnchor, constant: -10).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.layer.cornerRadius = 5

    }

    @objc  func exit(){
        print("eexit")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInfoView() {
        let hostingController = UIHostingController(rootView: AboutView())
        present(hostingController, animated: true, completion: nil)
    }

    //MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //sceneView.debugOptions = [.showWorldOrigin]
        sceneView?.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView?.session.pause()
    }

    func endGame(scope: Int) {
        print("func")

        gameOverLabel.text = String(localized: "Game over\n Score: ") + String(scope)

        sceneView?.addSubview(gameOverLabel)

        gameOverLabel.centerXAnchor.constraint(equalTo: sceneView!.centerXAnchor).isActive = true
        gameOverLabel.centerYAnchor.constraint(equalTo: sceneView!.centerYAnchor).isActive = true
        tetris = nil
//        configExit()
    }

}

protocol TetrisView {
    func endGame(scope: Int)
    func editScore(str: String)
}

extension ARViewController: TetrisView {

    func editScore(str: String) {
        scoreLabel.text = str
    }
}
