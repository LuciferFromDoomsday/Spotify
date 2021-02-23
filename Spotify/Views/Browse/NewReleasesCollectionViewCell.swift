//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by admin on 2/23/21.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private var albumCoverImageView : UIImageView = {
        let iImage = UIImageView()
        
        iImage.image = UIImage(systemName: "photo")
        
        iImage.contentMode = .scaleAspectFill
            
        return iImage
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22 , weight : .semibold)
        return label
    }()
    
    private let numberOfTrucksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .thin)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTrucksLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       
        artistNameLabel.sizeToFit()
        numberOfTrucksLabel.sizeToFit()
        
        let imageSize = contentView.height - 10
        
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(
            width: contentView.width - imageSize - 10,
            height: contentView.height - 10))
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: 5 ,
                                      width: albumLabelSize.width,
                                      height: min(60 , albumLabelSize.height))
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: albumNameLabel.bottom ,
                                      width: contentView.width - albumCoverImageView.right - 10,
                                      height: 30)
        
        
        numberOfTrucksLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: contentView.bottom - 44,
                                      width: numberOfTrucksLabel.width + 5,
                                      height: 50)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTrucksLabel.text = nil
        albumCoverImageView.image = nil
        
        
    }
    
    func configure(with viewModel : NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artsitsName
        numberOfTrucksLabel.text = "Tracks count: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
