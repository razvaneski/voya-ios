//
//  ErrorViewModifier.swift
//  TestApp
//
//  Created by Razvan Dumitriu on 04.09.2025.
//

import SwiftUI
import Combine

struct ErrorViewModifier: ViewModifier {
    @State private var error: Error?
    let errorSubject: PassthroughSubject<Error, Never>
    let onDismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            if let error {
                errorView(error)
                    .onTapGesture {
                        withAnimation {
                            self.error = nil
                            self.onDismiss?()
                        }
                    }
            }
        }
        .onReceive(errorSubject) { error in
            withAnimation {
                self.error = error
            }
        }
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        ZStack {
            VStack(spacing: 12) {
                Text("Error!")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let apiError = error as? APIClientError {
                    switch apiError {
                    case .httpCodeError(let code):
                        Text("Code: \(code)")
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .invalidResponse:
                        Text("Invalid response")
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .decodingError:
                        Text("Decoding error")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else if let imageDownloaderError = error as? ImageDownloaderError {
                    switch imageDownloaderError {
                    case .invalidImageData:
                        Text("Invalid image data")
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .invalidResponse:
                        Text("Invalid response")
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .invalidUrl:
                        Text("Invalid URL")
                            .frame(maxWidth: .infinity, alignment: .center)
                    case .requestError:
                        Text("Request error")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(20)
            .padding(16)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}

extension View {
    func withErrorHandling(_ errorSubject: PassthroughSubject<Error, Never>, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ErrorViewModifier(errorSubject: errorSubject, onDismiss: onDismiss))
    }
}
