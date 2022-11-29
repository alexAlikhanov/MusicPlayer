//
//  CollectionViewCell.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/24/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var hconstraint: NSLayoutConstraint!
    var wconstraint: NSLayoutConstraint!
    var imageView : UIImageView = {
       var img = UIImageView()
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        return img
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        super .init(frame:frame)
        backgroundColor = nil
        layer.cornerRadius = 10
        imageView.frame = CGRect(x: 2, y: 2, width: 150, height: 200)
        contentView.addSubview(imageView)
        contentView.layoutIfNeeded()
    }
    override func prepareForReuse() {
        imageView.image = nil
        imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        hconstraint  = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: -50)
        wconstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: -50)
        NSLayoutConstraint.activate([hconstraint, wconstraint])
        contentView.layoutIfNeeded()
    }
    
    func create(image: UIImage?){
        guard let image = image else { return }
        imageView.image = image
        contentView.layoutIfNeeded()
    }
    
    func scaleUp() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)})
    }
    func scaleDown() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
    }
    
}
