//
//  ViewController.swift
//  CircularLoaderLBTA
//
//  Created by David on 15/8/19.
//  Copyright © David. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController{
    var audioPlayer = AVAudioPlayer()
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var isPlay: Bool = false

    //let icon:UIImage =
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "😇"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 92)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 60
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        layer.borderColor = fillColor.cgColor
        layer.backgroundColor = fillColor.cgColor
        layer.borderWidth = 50
        layer.shadowOpacity = 5.0
        layer.shadowColor = #colorLiteral(red: 0.5065737963, green: 0.8325939775, blue: 0.2896941006, alpha: 0.7629227312)
        layer.lineCap = kCAGravityCenter
        
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //import audio library
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Serenity", ofType: "mp3")!))
            
            let audioSession = AVAudioSession.sharedInstance()
            do{
               try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                print(audioPlayer.duration)
            }
            catch{
       
            }
        }
        catch {
            print(error)
        }
    
 
        let layer1 = CAGradientLayer()
        layer1.frame = view.bounds
        layer1.colors = [UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.yellow.cgColor]
        layer1.startPoint = CGPoint(x: 0, y: 0.5)
        layer1.endPoint = CGPoint(x:1, y: 0.5)
        view.layer.addSublayer(layer1)
        
        setupCircleLayers()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupPercentageLabel()
    }
    
    
    private func setupPercentageLabel() {
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        percentageLabel.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.5, green: 1, blue: 0.5235980308, alpha: 0.6971318493), fillColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.8002461473))
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), fillColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.7279002568))
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.2497592038), fillColor: #colorLiteral(red: 0.6271087527, green: 0.8490449786, blue: 0.4607692957, alpha: 1))
    
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 10
        view.layer.addSublayer(shapeLayer)
    }
    // init circle animation
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.speed = 1
        
        
        pulsatingLayer.add(animation, forKey: "Pulsing")
    }

    
    // Progress Bar
    private func beginPlayMusic() {
        print("Attempting to play file")
        
        shapeLayer.strokeEnd = 00
        
        
        //Init Music Player
        
        audioPlayer.play()
        audioPlayer.currentTime = 0
        
        DispatchQueue.main.async {
            //self.percentageLabel.text = "\(Int(percentage * 100))%"
            
            // self.shapeLayer.strokeEnd = CGFloat(percentage)
            self.shapeLayer.strokeEnd = CGFloat(00)
            
        }
    }
    

    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        let durasi = audioPlayer.duration
        basicAnimation.toValue = 1
       //set loader sesuai durasi lagu
        basicAnimation.duration = durasi
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        //loader kembali seperti semula
        shapeLayer.speed = 0.8
        shapeLayer.timeOffset = 0
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @objc private func handleTap() {
        print("Attempting to animate stroke")
    
        if isPlay == false{
            beginPlayMusic()
            animateCircle()
            isPlay = true
        }
        else
        {
            audioPlayer.stop()
            isPlay = false
            let pausedTime : CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)  //ambil waktu saat pause
            shapeLayer.speed = 0.0 //speed jadi 0 seakan-akan loader di stop
            shapeLayer.timeOffset = pausedTime //set progress loader jadi waktu saat pause
        }
        
    }

}
















