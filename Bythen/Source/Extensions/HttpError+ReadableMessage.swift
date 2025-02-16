//
//  HttpError+ErrorMessage.swift
//  Bythen
//
//  Created by Ega Setya on 20/01/25.
//

extension HttpError {
    var readableMessage: String {
        guard let infos = self.infos else {
            return (self.description ?? "").firstCapitalized
        }
        
        guard let firstInfo = infos.first else {
            return self.message.firstCapitalized
        }
        
        return firstInfo.message.firstCapitalized
    }
}
