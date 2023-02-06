//
//  MovieListView.swift
//  USG04
//
//  Created by 백대홍 on 2023/02/06.
//

import SwiftUI

struct Movie: Codable, Hashable {
    let title: String
    let image: String
}

struct Actor: Codable, Hashable {
    let _id: String
    let name: String
    let image: String
}
struct MovieResponse: Codable {
    let data: [Movie]
}
struct ActorResponse: Codable {
    let data: [Actor]
}

struct MovieListView: View {
    @State private var Movies:[Movie] = []
    @State private var Actors:[Actor] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationStack {
                ScrollView(.horizontal){
                    HStack(alignment: .center) {
                        ForEach(Movies, id: \.self) { item in
                            AsyncImage(url: URL(string:"http://mynf.codershigh.com:8080"+item.image)) { image in
                                image.resizable()
                                    .frame(width: 150, height:200)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    HStack(alignment: .center) {
                        ForEach(Actors, id: \.self) { item in
                            AsyncImage(url: URL(string:"http://mynf.codershigh.com:8080"+item.image)) { image in
                                image.resizable()
                                    .frame(width: 150, height:200)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
                .navigationTitle("Movie")
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        Button {
                            fetchMovieAndActorList()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    
    func fetchMovieAndActorList() {
        print("fetchMovieAndActorList")
        // 1. URL
        let movieUrlStr = "http://mynf.codershigh.com:8080/api/movies"
        let movieUrl = URL(string: movieUrlStr)!
        let actorUrlStr = "http://mynf.codershigh.com:8080/api/actors"
        let actorUrl = URL(string: actorUrlStr)!
        
        // 2. Request
        let movieRequest = URLRequest(url: movieUrl)
        let actorRequest = URLRequest(url: actorUrl)
        
        // 3. Session, Task
        
        URLSession.shared.dataTask(with: movieRequest) { data, response, error in
            do {
                let ret = try JSONDecoder().decode(MovieResponse.self, from: data!)
                for item in ret.data {
                    self.Movies.append(item)
                }
            } catch {
                print("Error", error)
            }
        }.resume()
        
        URLSession.shared.dataTask(with: actorRequest) { data, response, error in
            do {
                let ret = try JSONDecoder().decode(ActorResponse.self, from: data!)
                for item in ret.data {
                    self.Actors.append(item)
                }
            } catch {
                print("Error", error)
            }
        }.resume()
    }
}
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
