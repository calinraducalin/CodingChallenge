//
//  VehicleImageCell.swift
//  Adevinta
//
//  Created by Calin Radu Calin on 08.01.2022.
//

import UIKit
import Kingfisher

final class VehicleImageCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with item: VehicleImageItem) {
        imageView.kf.setImage(
            with: item.url,
            placeholder: UIImage(systemName: "car"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }

}

private extension VehicleImageCell {

    func setupImageView() {
        contentView.addSubview(imageView)
        imageView.activateEdgeConstraints()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }

}
