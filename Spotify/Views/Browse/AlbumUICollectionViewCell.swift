//
//  UICollectionViewCell.swift
//  Spotify
//
//  Created by admin on 3/2/21.
//

import UIKit

class AlbumUICollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumUICollectionViewCell"
    
        
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18 , weight : .regular)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15 , weight : .thin)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 20
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     

        trackNameLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.width - 15,
                                      height: contentView.height/2)
        
       artistNameLabel.frame = CGRect(x: 10,
                                      y: contentView.height/2,
                                      width: contentView.width - 15,
                                      height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
       artistNameLabel.text = nil
        
        trackNameLabel.text = nil

        
        
    }
    
    func configure(with viewModel : AlbumTrackUICOllectionViewCellViewModel){
       trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artsitsName
    }
}
