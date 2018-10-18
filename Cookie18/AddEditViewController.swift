//
//  AddEditViewController.swift
//  cookie
//
//  Created by Bob Wint on 9/2/18.
//  Copyright © 2018 BWInc. All rights reserved.
//

import UIKit

protocol AddEditViewControllerDelegate: class {
    func addItemViewControllerDidCancel (controller: AddEditViewController)
    func addItemViewController (controller: AddEditViewController, didFinishAddingItem cookieItem: cookie)
    func addItemViewController (controller: AddEditViewController, didFinishEditingItem cookieItem: cookie)
}

class AddEditViewController : UITableViewController, UITextFieldDelegate {
    var newcookie: cookie?
    var cookieToEdit: cookie?
    
    var likeVar: Bool = true
    weak var delegate: AddEditViewControllerDelegate?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBAction func likeClicked(_ sender: Any) {
        likeVar = true
        toggleLike()
    }
    
    @IBAction func dislikeClicked(_ sender: Any) {
        likeVar = false
        toggleLike()
    }
    
    func toggleLike() {
        if likeVar == true {
            dislikeButton.backgroundColor = UIColor.clear
            likeButton.backgroundColor = UIColor.green
        } else {
            dislikeButton.backgroundColor = UIColor.red
            likeButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var dozenTxt: UITextField!

    @IBAction func doneClicked() {
        if let item = cookieToEdit {
            item.like = likeVar
            item.cookieName = nameTxt.text!
            item.cookieDescription = descTxt.text!
            item.cookieDozens = dozenTxt.text!
            delegate?.addItemViewController(controller: self, didFinishEditingItem: item)
        } else {
            newcookie = cookie()
            newcookie?.cookieName = nameTxt.text!
            newcookie?.cookieDescription = descTxt.text!
            newcookie?.cookieDozens = dozenTxt.text!
            newcookie?.like = likeVar
            delegate?.addItemViewController(controller: self, didFinishAddingItem: newcookie!)            
        }
    }
    
    @IBAction func cancelClicked() {
        delegate?.addItemViewControllerDidCancel(controller: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text! as NSString
        let newText : NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneButton.isEnabled = (newText.length > 0) // only enable button if text present
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTxt {
            nameTxt.resignFirstResponder()
            descTxt.becomeFirstResponder()
        } else {
            descTxt.resignFirstResponder()
        }
        return true
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil      // prevents the button row from being selected for editing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        if let item = cookieToEdit {
            title = "Edit Chef"
            nameTxt.text = item.cookieName
            descTxt.text = item.cookieDescription
            dozenTxt.text = item.cookieDozens
            likeVar = item.like
            doneButton.isEnabled = true
        } else {
            title = "Add Chef"
        }
        
        toggleLike()
        // field to auto-select when form first opens
        nameTxt.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
   }

    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
