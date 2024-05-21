//
//  ARVC+ARSCNDelegate.swift
//  Tetris
//
import Foundation
import SceneKit
import ARKit

extension ARViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            if arr != [[]] {return}
            let planeNode = createFloorNode(anchor: planeAnchor)
            for nodes in planeNode {
                node.addChildNode(nodes)
            }
        figure = node
        }
}
