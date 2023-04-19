
import Foundation

@objc protocol ReloadUIProtocol: AnyObject {
     @objc optional func reloadImage(dataImage: Data?)
     @objc optional func reloadText(data: Double)
     @objc optional func reloadTableView()
     @objc optional func reloadTableViewImage(tableViewImage: Data?)
     @objc optional func sendError(error: Error)
}
