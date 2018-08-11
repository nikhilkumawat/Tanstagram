//
//  ViewController.swift
//  Tanstagram
//
//  Created by SCL IT on 10/08/18.
//  Copyright © 2018 Nikhil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var images: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGestures()
    }

    @IBAction func saveToPhotosTapGesture(_ sender: UITapGestureRecognizer) {
        renderImage()
    }
    
    
    
    // Set Gestures
    func pinchGesture(imageView: UIImageView) -> UIPinchGestureRecognizer {
        // target-> need to look at self for the uipinchguesture
        // action-> what action actually happens when gusture execute
        // #selector-> selector look the function then that function execute (handle pinch)
        return UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinch))
    }
    
    func panGesture(imageView: UIImageView) -> UIPanGestureRecognizer{
        return UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan))
    }
    
    func rotationGesture(imageView: UIImageView) -> UIRotationGestureRecognizer{
        return UIRotationGestureRecognizer(target: self, action: #selector(ViewController.handleRotation))
    }
    
    // Handle Gestures
    @objc func handlePinch(sender: UIPinchGestureRecognizer){
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func handleRotation(sender: UIRotationGestureRecognizer){
        sender.view?.transform = (sender.view?.transform)!.rotated(by: sender.rotation)
        sender.rotation = 0
    }
   
    // Create Gestures
    func createGestures(){
        for shape in images{
            let pinch = pinchGesture(imageView: shape)
            let pan = panGesture(imageView: shape)
            let rotation = rotationGesture(imageView: shape)
            shape.addGestureRecognizer(pinch)
            shape.addGestureRecognizer(pan)
            shape.addGestureRecognizer(rotation)
        }
    }
    
    func renderImage(){
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { (goTo) in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ViewController.renderComplete), nil)
    }
    
    @objc func renderComplete(_image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error{
            
            //Error Occurred
            let alert = UIAlertController(title: "Somethig Went Wrong :(", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        } else{
            let alert = UIAlertController(title: "Photo Saved!", message: "Your image has been saved to your Camera Roll.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}

