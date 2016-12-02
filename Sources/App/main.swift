import Vapor
import AppLogic

let drop = try AppLogic.configureDroplet()

drop.run()
