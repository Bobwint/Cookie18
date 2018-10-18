//
//  ViewController.swift
//  cookie
//
//  Created by Bob Wint on 8/26/18.
//  Copyright © 2018 BWInc. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, AddEditViewControllerDelegate {
    
    var cookieData : [cookie] = []
    var editIndexPath : NSIndexPath?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // create array that will hold cookie objects
        cookieData = [cookie]()
        loadcookies()
    }

    func loadcookies() {
        let path = getDataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            cookieData = unarchiver.decodeObject(forKey: "cookieData") as! [cookie]
            unarchiver.finishDecoding()
        }
    }

    func addItemViewControllerDidCancel(controller: AddEditViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addItemViewController(controller: AddEditViewController, didFinishAddingItem  cookieItem: cookie) {
        addItem(cookieItem: cookieItem)
        dismiss(animated: true, completion: nil)
        savecookieItems()
    }

    func addItemViewController(controller: AddEditViewController, didFinishEditingItem  cookieItem: cookie) {
        if let cell = tableView.cellForRow(at: editIndexPath! as IndexPath) {
            cell.textLabel?.text = cookieItem.cookieName
            cell.detailTextLabel?.text = cookieItem.cookieDescription
            cookieData[editIndexPath!.row].cookieDescription = cookieItem.cookieDescription
            cookieData[editIndexPath!.row].cookieName = cookieItem.cookieName
            cookieData[editIndexPath!.row].cookieDozens = cookieItem.cookieDozens
            cookieData[editIndexPath!.row].like = cookieItem.like
        }
        dismiss(animated: true, completion: nil)
        savecookieItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "add" is in Main.storyboard (see Storyboard Segue "identifier" property)
        if segue.identifier == "add" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditViewController
            controller.delegate = self
        } else if segue.identifier == "edit" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddEditViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.cookieToEdit = cookieData[indexPath.row]
                editIndexPath = indexPath as NSIndexPath?
            }
        }
        buildChefLabel.setTitle("Find Solution", for: .normal)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cookieData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cookieCell", for: indexPath)
        cell.textLabel?.text = cookieData[indexPath.row].cookieName
        cell.detailTextLabel?.text = cookieData[indexPath.row].cookieDescription
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(cookieData[indexPath.row].cookieName)
    }

// Add row function (get next row, create new data items, add to array, add to table)
    func addItem(cookieItem: cookie) {
        let currentIndex = cookieData.count
        cookieData.append(cookieItem)
        let indexPath = IndexPath(row: currentIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

// Delete row function (remove from array, remove from table)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cookieData.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        savecookieItems()
    }

    // saving data between executions (data persistence)
    func getDataFilePath() -> URL {
        // get list of directories in my sandbox (returns an array of strings)
        var paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // returns the first path from paths array and appends a desired filename creating a property list
        return paths[0].appendingPathComponent("cookie.plist")
    }

    func savecookieItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(cookieData, forKey: "cookieData")
        archiver.finishEncoding()
        data.write(to: getDataFilePath(), atomically: true)
    }

    @IBOutlet weak var buildChefLabel: UIButton!
    @IBAction func buildChefListClicked (_ sender: Any) {
        buildChefLabel.setTitle("Tester", for: .normal)
        createChefLists()
    }

    func createChefLists() {
        // must have at least 2 chefs else abort
        if cookieData.count <= 1 {
            print("WARNING: You need at least 2 participants in order to have an exchange. Add more people and try the code again.")
            buildChefLabel.setTitle("Warning: Not Enough Chefs", for: .normal)
            return
        }
        // display arrays
        var chef = [String]()
        var cookie = [String]()
        var dozens = [Int]()
        var like = [Bool]()

        // calculation vars/arrays
        let openChar:String = " "
        let usedChar:String = "X"
        let firstIndex = 0
        let lastIndex = cookieData.count - 1
        var currIndex = 0
        var nextIndex = 1
        var toTakeCnt = [Int]()
        var toGiveCnt = [Int]()
        // initialize 2-dim array
        var chefArray = Array(repeating: Array(repeating: openChar, count: cookieData.count), count: cookieData.count)

        // populate display arrays
        for item in cookieData {
            chef.append(item.cookieName)
            cookie.append(item.cookieDescription)
            dozens.append(Int(item.cookieDozens)!)
            like.append(item.like)
        }

        // sort chefs in descending dozen sequence
        let sortedTuples = dozens.enumerated().sorted { $0.1 > $1.1 }
        let indicies = sortedTuples.map { $0.0 }
        dozens = indicies.map { dozens[$0] }
        chef = indicies.map { chef[$0] }
        cookie = indicies.map { cookie[$0] }
        like = indicies.map { like[$0] }
        for index in firstIndex...lastIndex {
            print("\(dozens[index]) \(chef[index])")
        }

        print("21--------------")
        toTakeCnt = dozens
        toGiveCnt = dozens
        for index in firstIndex...lastIndex {
            print(dozens[index], chefArray[index], toTakeCnt[index], toGiveCnt[index], chef[index], cookie[index])
        }

        // Populate each chef array
        var updateable : Bool
        for i in firstIndex...lastIndex {
            if lastIndex == 0 { break }
            currIndex = i
            for j in i+1...i+lastIndex {
                nextIndex = j
                if nextIndex > lastIndex {          // if past end of array
                    nextIndex -= cookieData.count   // reset back to 0
                }
                if nextIndex == currIndex {                         // if back to start of loop
                    break                                           // exit
                }
                updateable = true                                   // test for valid position
                if chefArray[currIndex][nextIndex] != openChar { updateable = false }   // is it open
                if toTakeCnt[currIndex] == 0 { updateable = false } // does taker still need more dozens
                if toGiveCnt[nextIndex] == 0 { updateable = false } // does giver still have dozens to give
                if updateable == true {
                    chefArray[currIndex][nextIndex] = usedChar      // update takers open position
                    toTakeCnt[currIndex] -= 1                       // reduce takers needed dozens by 1
                    toGiveCnt[nextIndex] -= 1                       // reduce givers available dozens by 1
                    if toTakeCnt[currIndex] == 0 { break }      // exit if no more to take
                }   // loop back and check next giver
            }   // loop back and process next taker
        }   // all takers have been processed
        print("22--------------")
        for index in firstIndex...lastIndex {
            print(dozens[index], chefArray[index], toTakeCnt[index], toGiveCnt[index])
        }
        // fix leftovers if they exist
        if toTakeCnt.reduce(0, +) > 0 {
            print("toTakeCnt fix needed", toTakeCnt.reduce(0, +))
        }
        var helpIndexValid: Bool
        for i in firstIndex...lastIndex {
            if lastIndex == 0 { break }
            if toTakeCnt[i] > 0 {   // find chef i who still needs cookies
                for j in firstIndex...lastIndex {
                    if toGiveCnt[j] > 0 {   // find chef j who still has cookies to give
                        for k in firstIndex...lastIndex {
                            helpIndexValid = true   // find chef k who is not chef i or chef j but can take from chef i and can give to chef j
                            if k == i { helpIndexValid = false }
                            if k == j { helpIndexValid = false }
                            print("i", i, "j", j, "k", k, helpIndexValid)
                            if helpIndexValid == true {
                                for m in firstIndex...lastIndex {
                                    print("i", i, "j", j, "k", k, "m", m)
                                    if chefArray[k][m] == openChar && k != m {    // find open take column in chef k that is also not itself
                                        for n in firstIndex...lastIndex {
                                            if chefArray[k][n] == usedChar && chefArray[i][n] == openChar && i != n {
                                                chefArray[k][m] = usedChar
                                                chefArray[k][n] = openChar
                                                chefArray[i][n] = usedChar
                                                toTakeCnt[i] -= 1
                                                toGiveCnt[j] -= 1
                                                print("26--------------")
                                                for index in firstIndex...lastIndex {
                                                    print(dozens[index], chefArray[index], toTakeCnt[index], toGiveCnt[index], chef[index])
                                                }
                                                if toTakeCnt.reduce(0, +) == 0 { break }
                                            }
                                        }
                                        if toTakeCnt.reduce(0, +) == 0 { break }
                                    }
                                }
                                if toTakeCnt.reduce(0, +) == 0 { break }
                            }
                        }
                        if toTakeCnt.reduce(0, +) == 0 { break }
                    }
                }
                if toTakeCnt.reduce(0, +) == 0 { break }
            }
        }
        if toTakeCnt.reduce(0, +) != 0 {
            print("FAILED: No solution is possible. The chef who brought the most cookies needs to take back home a dozen or you need to add more chefs to the exchange. Correct the issue and then retry the code.")
            buildChefLabel.setTitle("Failed: No Solution Found", for: .normal)
        } else {
            print("SUCCESS: Exchange solution created.")
            buildChefLabel.setTitle("Success: Solution Found", for: .normal)
        }
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create new cookie object and populate its properties
        print (getDataFilePath())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
