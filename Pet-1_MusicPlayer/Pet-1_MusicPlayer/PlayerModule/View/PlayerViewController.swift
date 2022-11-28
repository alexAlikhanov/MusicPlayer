//
//  PlayerViewController.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/22/22.
//

import UIKit

class PlayerViewController: UIViewController {

    var presenter: PlayerViewPresenterProtocol?
    var collectionView: UICollectionView?
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        createCollectionView()
        presenter?.setTrack()
        setupConstraints()
    }
       
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
   
    }
       
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           view.layoutIfNeeded()
            configureCollectionViewLayoutItemSize()
            if let index = presenter?.data?.correntItem {
            let indexPath = IndexPath(row: index, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                
            guard let cell = layout.collectionView?.cellForItem(at: indexPath) as? CollectionViewCell else {return}
            if let bool = presenter?.data?.isPlaying {
                if bool {
                    cell.scaleUp()
                }
            }
        }
    }
    @objc func onTap(){
           self.presenter?.back()
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
        collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
    }
}

extension PlayerViewController: PlayerViewProtocol {
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
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < presenter?.data?.tracks.count ?? 0 && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = layout.itemSize.width * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
            guard let bcell = collectionView?.cellForItem(at: IndexPath(row: indexOfCellBeforeDragging, section: 0)) as? CollectionViewCell else {return}
            bcell.scaleDown()
            guard let cell = collectionView?.cellForItem(at: IndexPath(row: snapToIndex, section: 0)) as? CollectionViewCell else {return}
            if let track = presenter?.data?.tracks[snapToIndex]{
                presenter?.getTrackResponce(responce:track)
                presenter?.data?.correntItem = snapToIndex
            }
            if let bool = presenter?.data?.isPlaying {
                if bool {
                    cell.scaleUp()
                }
            }
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let beckIndexPath = IndexPath(row: indexOfCellBeforeDragging, section: 0)
            guard let cell = collectionView?.cellForItem(at:indexPath) as? CollectionViewCell else {return}
            if let track = presenter?.data?.tracks[indexPath.row]{
                presenter?.getTrackResponce(responce:track)
                presenter?.data?.correntItem = indexPath.row
            }
            if let bool = presenter?.data?.isPlaying {
                if bool {
                    cell.scaleUp()
                }
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
}
