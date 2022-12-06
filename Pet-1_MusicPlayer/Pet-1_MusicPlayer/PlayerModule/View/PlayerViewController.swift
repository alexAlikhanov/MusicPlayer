//
//  PlayerViewController.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import UIKit

class PlayerViewController: UIViewController {

    public var presenter: PlayerViewPresenterProtocol?
    private var collectionView: UICollectionView?
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var indexOfCellBeforeDragging = 0
    private let slider: UISlider = {
        var slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var currentTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        return label
    }()
    private var durationTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        view.addSubview(slider)
        view.addSubview(currentTimeLabel)
        view.addSubview(durationTimeLabel)
        slider.addTarget(self, action: #selector(changeValue(sender:)), for: .valueChanged)
        createCollectionView()
        presenter?.setTrack()
        setupConstraints()
        
    }
       
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
            if let index = presenter?.data?.correntItem {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = layout.collectionView?.cellForItem(at: indexPath) as? CollectionViewCell else {return}
            if let bool = presenter?.data?.isPlaying {
                if bool {
                    cell.scaleUp()
                }
            }
        }
    }
       
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           view.layoutIfNeeded()
            configureCollectionViewLayoutItemSize()
        if let index = presenter?.data?.correntItem {
            let indexPath = IndexPath(row: index, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    @objc func onTap(){
           self.presenter?.back()
    }
    @objc func changeValue(sender: UISlider){
        presenter?.refrashData(currentTime: sender.value)
    }
    
    
    private func createCollectionView(){
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: CGRect(x: 10, y: 10, width: 10, height: 10),  collectionViewLayout: layout)
        collectionView?.backgroundColor = nil
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.isPagingEnabled = false
        collectionView?.isScrollEnabled = true
        collectionView?.isPrefetchingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView ?? UICollectionView())
    }
    
    private func setupConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: 300).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height/10).isActive = true
        
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 5/6).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.centerYAnchor.constraint(equalTo: collectionView!.bottomAnchor, constant: 150).isActive = true
        
        currentTimeLabel.leftAnchor.constraint(equalTo: slider.leftAnchor).isActive = true
        currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10).isActive = true
        durationTimeLabel.rightAnchor.constraint(equalTo: slider.rightAnchor).isActive = true
        durationTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10).isActive = true
    }
}

extension PlayerViewController: PlayerViewProtocol {
    func refrashSlider(currentTime: TimeInterval, duration: TimeInterval) {
        slider.minimumValue = 0
        slider.maximumValue = Float(duration)
        slider.setValue(Float(currentTime), animated: true)
        
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        let dminutes = (Int(duration) / 60) - minutes
        let dseconds = (Int(duration) % 60) - seconds
        
        if seconds < 10 {
            currentTimeLabel.text = "\(minutes):0\(seconds)"
        } else {
            currentTimeLabel.text = "\(minutes):\(seconds)"
        }
        if dseconds < 10 {
            durationTimeLabel.text = "\(dminutes):0\(dseconds)"
        } else {
            durationTimeLabel.text = "\(dminutes):\(dseconds)"
        }
    }
    
    func setupPlayingTrackLineInCollecrion(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func action(flag: Bool) {
        guard let cell = collectionView?.cellForItem(at: IndexPath(row: presenter?.data?.correntItem ?? 0, section: 0)) as? CollectionViewCell else {return}
        if flag {
            cell.scaleUp()
        }else {
            cell.scaleDown()
        }
    }
    func setTrack(data: MusicData?) {
        collectionView?.reloadData()
    }
    
}

extension PlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.data?.tracks.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.create(image: presenter?.data?.images[indexPath.row])
        return cell
    }
}

extension PlayerViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < presenter?.data?.tracks.count ?? 0 && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = layout.itemSize.width * CGFloat(snapToIndex)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            guard let bcell = collectionView?.cellForItem(at: IndexPath(row: indexOfCellBeforeDragging, section: 0)) as? CollectionViewCell else {return}
            bcell.scaleDown()
            if let track = presenter?.data?.tracks[snapToIndex]{
                presenter?.getTrackResponce(responce:track)
                presenter?.data?.correntItem = snapToIndex
            }

        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let beckIndexPath = IndexPath(row: indexOfCellBeforeDragging, section: 0)
            
            if let track = presenter?.data?.tracks[indexPath.row]{
                presenter?.getTrackResponce(responce:track)
                presenter?.data?.correntItem = indexPath.row
            }
            guard let bcell = collectionView?.cellForItem(at:beckIndexPath) as? CollectionViewCell else {return}
            bcell.scaleDown()
        }
    }
}

extension PlayerViewController {
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        let buttonWidth: CGFloat = 50
        let inset = (layout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        layout.itemSize = CGSize(width: layout.collectionView!.frame.size.width - inset * 2, height: layout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = layout.itemSize.width
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(presenter?.data?.tracks.count ?? 0 - 1, index))
        return safeIndex
    }
}
