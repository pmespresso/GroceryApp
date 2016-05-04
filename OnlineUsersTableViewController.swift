/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class OnlineUsersTableViewController: UITableViewController {

  // MARK: Constants
  let UserCell = "UserCell"
    let usersRef = Firebase(url: "https://grocrex.firebaseio.com/online")

  // MARK: Properties
  var currentUsers: [String] = [String]()
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        usersRef.observeEventType(.ChildAdded) { (snap: FDataSnapshot!) in
            self.currentUsers.append(snap.value as! String)
            
            let row = self.currentUsers.count - 1
            
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        }
        
        usersRef.observeEventType(.ChildRemoved) { (snap: FDataSnapshot!) in
            let emailToFind = snap.value as! String
            
            for (index, email) in self.currentUsers.enumerate() {
                if email == emailToFind {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    
                    self.currentUsers.removeAtIndex(index)
                    
                    self.tableView.deleteRowsAtIndexPaths(
                        [indexPath], withRowAnimation: .Fade)
                }
            }
            
        }
    }

  // MARK: UITableView Delegate methods
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(UserCell)! as UITableViewCell
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }

  
}
