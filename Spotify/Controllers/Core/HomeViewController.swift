//
//  ViewController.swift
//  Spotify
//
//  Created by admin on 2/16/21.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels : [NewReleasesCellViewModel]) // 1
    case featuredPlaylist(viewModels : [FeaturedPlaylistCellViewModel])  // 2
    case recommendedTracks(viewModels : [RecommendedTrackCellViewModel]) //3
    
 var title : String  {
        switch self {
        case .newReleases:
            return "New Releases"
            
        case .featuredPlaylist:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended For You"
        }
    }
}

class HomeViewController: UIViewController {
    private var newAlbums  : [Album] = []
    private var playlists  : [Playlist] = []
    private var tracks  : [AudioTrack] = []

    private var collectionView : UICollectionView = UICollectionView(frame : .zero , collectionViewLayout : UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection in
        
        return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"gear"),
             style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
       
   configureCollectionView()
        view.addSubview(spinner)
      
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "cell")
        collectionView.register(NewReleasesCollectionViewCell.self , forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self , forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self , forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        // configure Models
        
   
        
        
    }
    
   
    
        @objc func didTapSettings (){
            let vc = SettingsViewController()
            vc.title = "Settings"
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        }

    }



extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .newReleases( let viewModels):
            return viewModels.count
        case .featuredPlaylist(let viewModels):
            return viewModels.count
        case .recommendedTracks( let viewModels):
            return viewModels.count
        }
        
      
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .newReleases( let viewModels):
          guard  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleasesCollectionViewCell.identifier,
                    for: indexPath) as? NewReleasesCollectionViewCell else{
            return UICollectionViewCell()
          }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylist(let viewModels):
            guard  let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier,
                      for: indexPath) as? FeaturedPlaylistsCollectionViewCell else{
              return UICollectionViewCell()
            }
   
            cell.configure(with: viewModels[indexPath.row])
              return cell
        case .recommendedTracks( let viewModels):
            guard  let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier,
                      for: indexPath) as? RecommendedTracksCollectionViewCell else{
              return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
              return cell
        }
        

    }
    
  
        
    private func fetchData(){
      
        
        
       let group = DispatchGroup()
       
        group.enter()
        group.enter()
        group.enter()
        
        
        //New releases
        
        var newReleases : NewReleasesResponse?
        var featuredPlaylists : FeaturedPlaylistsResponse?
        var recommendations : RecommendationsResponse?
        APICaller.shared.getNewReleases{ result in
            
            defer {
       
                group.leave()
            }
            
            switch result{
            case .success(let model) :
                newReleases = model
            case  .failure(let error) :
                print(error.localizedDescription)
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturedPlaylists{ result in
            defer {
  
                group.leave()
            }
            switch result{
            case .success(let model) :
               featuredPlaylists = model
            case  .failure(let error) :
                print(error.localizedDescription)
            }
        }
        
        //Recommended tracks
        print("fetching rec")
        APICaller.shared.getRecommendedGenres{ result in
            switch result{
            case .success(let model) :
    
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                print(seeds)
                
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResults in
                  
                    defer {
                        
                        group.leave()
                    }
                    switch recommendedResults{
                    case .success(let model) :
                      
                      recommendations = model
                    case .failure(let error) :
                        
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error) :
    
                print(error.localizedDescription)
            }
        
        }
        //print("confugering models")
        group.notify(queue: .main){
            guard let releases = newReleases?.albums.items ,
                  let playlists = featuredPlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else {

                fatalError("Models are nill")
            }
           
            self.configureModels(newAlbums: releases, playlists: playlists, tracks: tracks)
        }

        
    }
    
 
    
    private func configureModels
    (
        newAlbums : [Album] ,
        playlists : [Playlist],
        tracks : [AudioTrack]
    ){
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        
        print(newAlbums.count)
        print(playlists.count)
        print(tracks.count)
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artsitsName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylist(viewModels :playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name )
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendedTrackCellViewModel(name: $0.name, artworkURL: URL(string: $0.album?.images.first?.url ?? ""), artsitsName: $0.artists.first?.name ?? "-")
        })))
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylist:
            let playlist = playlists[indexPath.row]
            let vc  = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let vc  = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks :
            break
      
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else{
           return  UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
        
    }
    
    static func createSectionLayout (section : Int) -> NSCollectionLayoutSection {
      let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize:
            NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)) ,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
          switch section{
          case 0 :
              let item = NSCollectionLayoutItem(layoutSize:
              NSCollectionLayoutSize(
                  widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
              )
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
              
              // Vertical group in horizontall
              let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .fractionalWidth(1.0),
                      heightDimension: .absolute(390)),
                      subitem: item ,
                      count: 3)
              
              
              let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .fractionalWidth(0.9),
                      heightDimension: .absolute(390)),
                      subitem: verticalGroup ,
                      count: 1)
              
              let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
              return section
              
          case 1 :
              
              let item = NSCollectionLayoutItem(layoutSize:
              NSCollectionLayoutSize(
                  widthDimension: .absolute(200),
                  heightDimension: .absolute(200))
              )
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
              
              // Vertical group in horizontall
              let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .absolute(200),
                      heightDimension: .absolute(400)),
                      subitem:    item ,
                      count: 2)
              
              
              let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .absolute(200),
                      heightDimension: .absolute(400)),
                      subitem:    verticalGroup ,
                      count: 1)
              
              let section = NSCollectionLayoutSection(group: horizontalGroup)
              section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryView
              return section
              
          case 2 :
              
              let item = NSCollectionLayoutItem(layoutSize:
              NSCollectionLayoutSize(
                  widthDimension: .fractionalWidth(1.0),
                  heightDimension: .fractionalHeight(1.0)
              )
          )
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
              
      
              
              let group = NSCollectionLayoutGroup.vertical(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .fractionalWidth(1),
                      heightDimension: .absolute(90)),
                      subitem: item,
                      count: 1)
              
              let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
              return section
              
          default :
              let item = NSCollectionLayoutItem(layoutSize:
              NSCollectionLayoutSize(
                  widthDimension: .fractionalWidth(1.0),
                  heightDimension: .fractionalHeight(1.0))
              )
              
              item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
              
              // Vertical group in horizontall
              let group = NSCollectionLayoutGroup.vertical(layoutSize:
                     NSCollectionLayoutSize(
                      widthDimension: .fractionalWidth(1.0),
                      heightDimension: .absolute(390)),
                      subitem: item ,
                      count: 1)
              
              
              let section = NSCollectionLayoutSection(group: group)
             return section
          }
          
      }
      
}
