//
//  AdView.swift
//  jxjzfp
//
//  Created by AlphaDog on 2018/3/14.
//  Copyright © 2018年 RuiXun. All rights reserved.
//

import UIKit

open class RXAdView: UIView {
    
    @objc open var willDismiss: () -> Void = {}
    @objc open var bgImgClick: (() -> Void)? {
        didSet {
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(bgImgAction))
            bgImgView.addGestureRecognizer(tapGesture)
        }
    }
    
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    @objc open var staySeconds: Int = 5
    
    @objc open var skipBtnColor: UIColor = .white {
        didSet {
            skipBtn.setTitleColor(skipBtnColor, for: .normal)
            skipBtn.layer.borderColor = skipBtnColor.cgColor
        }
    }
    
    @objc open var defaultImg: UIImage? {
        didSet {
            bgImgView.image = defaultImg
        }
    }
    
    @objc open var imgUrl: String? {
        didSet {
            guard let url = imgUrl else {
                return
            }
            let paths = url.components(separatedBy: "/")
            if isFilePahtExist(fileName: paths.last!) {
                guard let imgData = try? Data.init(contentsOf: URL.init(string: url)!) else {
                    return
                }
                self.bgImgView.image = UIImage.init(data: imgData)!
                startTimer()
            } else {
                getAdImg(url: url)
            }
        }
    }
    
    //MARK: - Controls
    open var bgImgView: UIImageView = {
        let imgView = UIImageView();
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    open var skipBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitle("跳过", for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        addSubview(bgImgView)
        addSubview(skipBtn)
        layout()
    }
    
    //MARK: - Layout
    open func layout() {
        ///bgImgView
        let xCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bgImgView]-0-|", options: .directionLeftToRight, metrics: nil, views: ["bgImgView": bgImgView])
        addConstraints(xCons)
        let yCons = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgImgView]-0-|", options: .directionLeftToRight, metrics: nil, views: ["bgImgView": bgImgView])
        addConstraints(yCons)
        
        ///skipBtn
        let skipW = NSLayoutConstraint(item: skipBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        skipBtn.addConstraint(skipW)
        let skipH = NSLayoutConstraint(item: skipBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        skipBtn.addConstraint(skipH)
        let skipX = NSLayoutConstraint(item: skipBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 36)
        addConstraint(skipX)
        let skipY = NSLayoutConstraint(item: skipBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -20)
        addConstraint(skipY)
    }
    
    //MARK: - Action
    open func startTimer() {
        DispatchTimer(timeInterval: 1, repeatCount: staySeconds) { (timer, count) in
            self.skipBtn.setTitle("跳过 \(count)", for: .normal)
            if count <= 0 {
                self.dismiss()
            }
        }
    }
    
    open func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->()) {
        if repeatCount <= 0 {
            return
        }
        
        var count = repeatCount
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(self.timer, count)
            }
            if count == 0 {
                self.timer.cancel()
            }
        })
        timer.resume()
    }
    
    @objc open func dismiss() {
        willDismiss()
        timer.cancel()
        removeFromSuperview()
    }
    
    @objc func bgImgAction() {
        willDismiss()
        timer.cancel()
        bgImgClick?()
        removeFromSuperview()
    }
    
}

//MARK: - Pic Action
extension RXAdView {
    
    fileprivate func getAdImg(url: String) {
        DispatchQueue.global().async {
            let imgUrl = URL.init(string: url)
            guard let imgData = try? Data.init(contentsOf: imgUrl!) else {
                return
            }
            DispatchQueue.main.async {
                self.bgImgView.image = UIImage.init(data: imgData)!
                self.startTimer()
                
                let paths = url.components(separatedBy: "/")
                self.saveImgWithPath(fileName: paths.last!, imgData: imgData)
            }
        }
    }
    
    fileprivate func saveImgWithPath(fileName: String, imgData: Data) {
        let filePath = getImgPath(fileName: fileName)
        if !(imgData as NSData).write(toFile: filePath, atomically: true) {
            return
        }
    }
    
    fileprivate func isFilePahtExist(fileName: String) -> Bool {
        let filePath = getImgPath(fileName: fileName)
        if let _ = UIImage(contentsOfFile: filePath) {
            return true
        }
        return false
    }
    
    fileprivate func getImgPath(fileName: String) -> String {
        var paths:[String] = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return (paths[0] as NSString).appending("/" + fileName)
    }
    
}
