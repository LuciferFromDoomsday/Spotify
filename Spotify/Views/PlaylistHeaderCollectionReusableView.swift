//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by admin on 3/1/21.
//
//import SDWebImage
import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate : AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header : PlaylistHeaderCollectionReusableView)
    
    
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
        static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate : PlaylistHeaderCollectionReusableViewDelegate?
    
    
    private let nameUILabel :UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22 , weight : .semibold)
        return label
    }()
    private let descriptionUILabel :UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18 , weight : .regular)
        return label
    }()
    private let ownerUILabel :UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18 , weight : .light)
        return label
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        
        return imageView
    }()
    
    private var playButton : UIButton = {
        let playButton = UIButton()
        playButton.backgroundColor = .systemGreen
        playButton.setImage(UIImage(systemName:"play.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)) , for: .normal)
        playButton.tintColor = .white
       
        playButton.layer.cornerRadius = 30
        playButton.layer.masksToBounds = true
        return playButton
    }()
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameUILabel)
        addSubview(descriptionUILabel)
        addSubview(ownerUILabel)
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(didTapPLayAll), for: .touchUpInside)
        
    }
    
    @objc private func didTapPLayAll(){
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = height / 1.8
        
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameUILabel.frame = CGRect(x: 10, y: imageView.bottom, width: width - 20, height: 44)
        descriptionUILabel.frame = CGRect(x: 10, y: nameUILabel.bottom, width: width - 20, height: 44)
        ownerUILabel.frame = CGRect(x: 10, y: descriptionUILabel.bottom, width: width - 20, height: 44)
        
        playButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
    }
    
    func configure(with viewModel : PlaylistHeaderCollectionReusableViewModel){
        
        nameUILabel.text = viewModel.name
        descriptionUILabel.text = viewModel.description
        ownerUILabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
    }
}

