//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by admin on 3/2/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel : UILabel = {
        let title = UILabel()
        title.textColor = .secondaryLabel
        title.numberOfLines  = 1
        title.font = .systemFont(ofSize: 20 , weight : .semibold)
        return title
    }()
    
    
   override init(frame :CGRect){
    super.init(frame: frame)
    backgroundColor = .systemBackground
    addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    func configure(with title : String){
        
        titleLabel.text = title
        
    }
    
}
