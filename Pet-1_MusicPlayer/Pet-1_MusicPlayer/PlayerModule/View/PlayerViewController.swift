//
//  PlayerViewController.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import UIKit

class PlayerViewController: UIViewController {

    var presenter: PlayerViewPresenterProtocol?
    
    var heightConstraint: NSLayoutConstraint!
    var yConstraint: NSLayoutConstraint!
    let views = UIView()
    override func viewDidLoad() {
           super.viewDidLoad()
        view.backgroundColor = .lightGray
           views.frame = CGRect(x: 0, y: view.safeAreaLayoutGuide.layoutFrame.size.height - 50, width: view.safeAreaLayoutGuide.layoutFrame.size.width, height: 0)
           views.backgroundColor = .lightGray
           view.addSubview(views)
           view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        presenter?.setTrack()
       }
       
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           setupConstraint()
           UIView.animate(withDuration: 0.5) {
               self.yConstraint.constant = 0
               self.view.layoutIfNeeded()
           }
       }
       
       private func setupConstraint(){
           views.translatesAutoresizingMaskIntoConstraints = false
           
           yConstraint = NSLayoutConstraint(item: views, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
           heightConstraint = NSLayoutConstraint(item: views, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
           NSLayoutConstraint.activate([
               views.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
               views.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
               heightConstraint, yConstraint
           ])
          
       }
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           view.layoutIfNeeded()
       }
       @objc func onTap(){
           self.presenter?.back()
       }

    
}

extension PlayerViewController: PlayerViewProtocol {
    func setTrack(data: MusicData?) {
        print(data?.images.count)
        print(data?.tracks.count)
        
    }
}
