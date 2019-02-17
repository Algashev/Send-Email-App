//
//  ViewController.swift
//  Send Email App
//
//  Created by Александр Алгашев on 16/02/2019.
//  Copyright © 2019 Александр Алгашев. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var createFileButton: UIButton!
    let csvManager = CSVManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createFileButton.layer.cornerRadius = 20
        sendEmailButton.layer.cornerRadius = 20
        
        controllerButton(createFileButton, isEnabeld: !csvManager.fileExists())
        controllerButton(sendEmailButton, isEnabeld: csvManager.fileExists())
    }

    @IBAction func sendEmailButtonPressed(_ sender: UIButton) {
        if !csvManager.fileExists() {
            let alert = UIAlertController(title: "Error occurred", message: "File does not exist.")
            self.present(alert, animated: true, completion: nil)
            print("File does not exist")
            return
        }
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["algashev@mail.ru"])
            composeVC.setSubject("Voca-Voca App Vocabulary")
            composeVC.setMessageBody("Your Vocabulary is in an attachment.", isHTML: false)

            if let attachmentData = csvManager.preperaToEmail() {
                composeVC.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: ManagerKeys.vocabularyFile)
                print("CSV file prepared successully for email.")
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error occurred", message: "Mail services are not available.")
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error occurred", message: "Failed to prepara file for email.")
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func createFileButtonPressed(_ sender: UIButton) {
        if csvManager.createCSV() {
            controllerButton(createFileButton, isEnabeld: false)
            controllerButton(sendEmailButton, isEnabeld: true)
            print("CSV file created successully.")
        } else {
            let alert = UIAlertController(title: "Error occurred", message: "Failed to create CSV file.")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func controllerButton(_ button: UIButton, isEnabeld: Bool) {
        button.isEnabled = isEnabeld
        button.alpha = button.isEnabled ? 1.0 : 0.5
    }
    
    //MARK:- MailcomposerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var resultMessage: String = ""
        switch result {
        case .cancelled:
            resultMessage = "User cancelled."
            break
            
        case .saved:
            resultMessage = "Mail is saved by user."
            break
            
        case .sent:
            resultMessage = "Mail is sent successfully."
            break
            
        case .failed:
            resultMessage = "Sending mail is failed."
            break
        default:
            break
        }
        
        print(resultMessage)
        controller.dismiss(animated: true)

        let alert = UIAlertController(title: "Mail services result", message: resultMessage)
        self.present(alert, animated: true, completion: nil)
        if csvManager.clearCSV() {
            controllerButton(createFileButton, isEnabeld: true)
            controllerButton(sendEmailButton, isEnabeld: false)
            print("CSV file deleted successully.")
        } else {
            let alert = UIAlertController(title: "Error occurred", message: "Failed to delete CSV file.")
            self.present(alert, animated: true, completion: nil)
        }
    }
}

