//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by admin on 3/2/21.
//

import UIKit
import SDWebImage
class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView : UIImageView = {
        let image = UIImageView()
        
        image.contentMode  = .scaleAspectFit
        
        image.tintColor = .white
        
        image.image = UIImage(systemName: "music.quarternote.3" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        
        return image
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let colors : [UIColor] = [.systemPurple , .systemPink , .systemBlue ,.systemGreen , .systemGray , .systemRed , .systemTeal , .systemGray2 , .systemOrange , .systemYellow ]
    
    override init(frame : CGRect){
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 20 , height: contentView.height / 2)
        imageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width / 2, height: contentView.height / 2)
    }
    
    func configure(with viewModel: CategoryUICollectionViewCellViewModel){
        label.text =  viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
