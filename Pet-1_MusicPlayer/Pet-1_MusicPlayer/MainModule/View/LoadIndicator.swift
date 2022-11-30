//
//  LoadIndicator.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

class LoadIndicator: UIView {

    static let shared = LoadIndicator(frame:CGRect(x: 0, y: 0, width: 10, height: 10))
    private let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private var timer: Timer!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = nil
        self.addSubview(ImageView)
        NSLayoutConstraint.activate([
            ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            ImageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    func startAnimate(){
        ImageView.isHidden = false
        if timer == nil {
        timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
        }
    }
    func stopAnimate(){
        ImageView.isHidden = true
        if timer != nil {
            timer.invalidate()
        }
        timer = nil
    }
    @objc func animateView() {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear, animations: {
            self.ImageView.transform = self.ImageView.transform.rotated(by: CGFloat(180))
            
        }, completion: { (finished) in
                    if self.timer != nil {
                        self.timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animateView), userInfo: nil, repeats: false)
            }
        })
    }
}
