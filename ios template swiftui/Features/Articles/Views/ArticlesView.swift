import SwiftUI

struct ArticleRowView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(article.title)
                .font(.headline)
            Text(article.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            if let date = article.date {
                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ArticlesView: View {
    @StateObject private var viewModel: ArticlesViewModel

    init(viewModel: ArticlesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else {
                    List(viewModel.articles) { article in
                        ArticleRowView(article: article)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Articles")
            .onAppear { viewModel.load() }
        }
    }
}
