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

struct MovieResponse: Codable {
    let data: [Movie]
}


struct MovieListView: View {
    @State private var Movies:[Movie] = []
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal){
                    HStack(alignment: .center) {
                        ForEach(Movies, id: \.self) { item in
                            NavigationLink(destination: DetailView()) {
                                AsyncImage(url: URL(string:"http://mynf.codershigh.com:8080"+item.image)) { image in
                                    image.resizable()
                                        .frame(width: 150, height:200)
                                } placeholder: {
                                    ProgressView()
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    .navigationTitle("Movie")
                    
                }
            }
            .onAppear(perform: fetchMovieList)
        }
    }
    
    
    func fetchMovieList() {
        print("fetchMovieList")
        // 1. URL
        let movieUrlStr = "http://mynf.codershigh.com:8080/api/movies"
        let movieUrl = URL(string: movieUrlStr)!
        
        // 2. Request
        let movieRequest = URLRequest(url: movieUrl)
        
        
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
        
    }
}
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
