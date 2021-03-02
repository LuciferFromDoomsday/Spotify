//
//  FeaturedPlaylistsCollectionViewCell.swift
//  Spotify
//
//  Created by admin on 2/23/21.
//

import UIKit

class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsCollectionViewCell"
    
    
    private var playlistCoverImageView : UIImageView = {
        let iImage = UIImageView()
        
        iImage.layer.masksToBounds = true
        iImage.layer.cornerRadius = 5
        iImage.image = UIImage(systemName: "photo")
        
        
        iImage.contentMode = .scaleAspectFill
            
        return iImage
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18 , weight : .regular)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15 , weight : .thin)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame : CGRect){
        super.init(frame: frame)

        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 30 ,
            width: contentView.width - 6,
            height: 44)
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-60 ,
            width: contentView.width - 6,
            height: 44)
        let imageSize = contentView.height - 50
        
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize)/2, y: 3, width: imageSize , height: imageSize)
  
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
       creatorNameLabel.text = nil
        
        playlistNameLabel.text = nil

        playlistCoverImageView.image = nil
        
        
    }
    
    func configure(with viewModel : FeaturedPlaylistCellViewModel){
       playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
