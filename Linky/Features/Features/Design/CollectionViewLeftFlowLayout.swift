//
//  CollectionViewLeftFlowLayout.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 8.0
        self.minimumInteritemSpacing = 4.0
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 42.0, bottom: 0.0, right: 42.0)

        let attributes = super.layoutAttributesForElements(in: rect)
 
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + 4.0
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
