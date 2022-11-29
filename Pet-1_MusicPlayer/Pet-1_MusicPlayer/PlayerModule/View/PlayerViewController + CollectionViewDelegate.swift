//
//  PlayerViewController + CollectionViewDelegate.swift
//  Pet-1_MusicPlayer
//
//  Created by Алексей on 11/29/22.
//

import UIKit

extension PlayerViewController: UICollectionViewDelegate {
    
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
        let inset: CGFloat = calculateSectionInset()
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

