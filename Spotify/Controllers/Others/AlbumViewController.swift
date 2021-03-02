//
//  AlbumViewController.swift
//  Spotify
//
//  Created by admin on 3/1/21.
//

import UIKit

class AlbumViewController: UIViewController {

    private let album : Album
    private let collectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ , _ -> NSCollectionLayoutSection? in
        
        let item = NSCollectionLayoutItem(layoutSize:
        NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize:
               NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)),
                subitem: item,
                count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
       
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
            NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)) ,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        
        return section
        
        
    }))
        
    init(album : Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private var viewModels = [AlbumTrackUICOllectionViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        collectionView.register(AlbumUICollectionViewCell.self , forCellWithReuseIdentifier: AlbumUICollectionViewCell.identifier)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        APICaller.shared.getAlbumDetails(for : album ){[weak self]result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                       AlbumTrackUICOllectionViewCellViewModel(name: $0.name,
                                                      artsitsName: $0.artists.first?.name ?? "-")
                       })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    
                    print(error.localizedDescription)
                
                }
            }
        }
    
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
        
    }
    



}




extension AlbumViewController : UICollectionViewDelegate , UICollectionViewDataSource{
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModels.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumUICollectionViewCell.identifier, for: indexPath) as? AlbumUICollectionViewCell else
    {
        return UICollectionViewCell()
    }
    cell.configure(with: viewModels[indexPath.row])
    
    return cell
    
}

func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard  let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader  else {
        return UICollectionReusableView()
    }
    let headerViewModel = PlaylistHeaderCollectionReusableViewModel(name: album.name, description: "Released date : " + String.formattedDate(string: album.release_date) , owner: album.artists.first?.name ?? "-", artworkURL: URL(string: album.images.first?.url ?? ""))
    
    header.configure(with: headerViewModel)
    header.delegate = self
  return header
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    // Play song
}
}

extension AlbumViewController : PlaylistHeaderCollectionReusableViewDelegate{
func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
    // Start playlist play all in queue
    print("play All")
}
}

