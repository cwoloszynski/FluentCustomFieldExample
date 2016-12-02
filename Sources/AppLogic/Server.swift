//
//  Server.swift
//  FluentTest
//
//  Created by Charlie Woloszynski on 12/2/16.
//
//
import Vapor
import VaporMySQL
import Fluent
import Jay
import Auth

public func configureDroplet(arguments:[String]? = nil) throws -> Droplet {

    let drop = Droplet(arguments: arguments)

    drop.preparations = [Post.self]
    
    try drop.addProvider(VaporMySQL.Provider.self)

    drop.get { req in
        return try drop.view.make("welcome", [
            "message": drop.localization[req.lang, "welcome", "title"]
            ])
    }

    drop.resource("posts", PostController())

    return drop
}
