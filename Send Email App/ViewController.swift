//
//  ViewController.swift
//  Send Email App
//
//  Created by Александр Алгашев on 16/02/2019.
//  Copyright © 2019 Александр Алгашев. All rights reserved.
//

import UIKit
import MessageUI

struct ControllerKeys {
    static let vocabularyFile: String = "Vocabulary.csv"
    static let vocabularyPath: URL = FileManager.default.temporaryDirectory.appendingPathComponent(ControllerKeys.vocabularyFile)
}

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var sendEmailButton: UIButton!
//    var path = FileManager.default.temporaryDirectory
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        path = path.appendingPathComponent(ControllerKeys.vocabularyFile)
        let csvText = "Date,Task,Time Started,Time Ended\n"
        print(ControllerKeys.vocabularyPath)
        do {
            try csvText.write(to: ControllerKeys.vocabularyPath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        sendEmailButton.layer.cornerRadius = 20
    }

    @IBAction func sendEmailButtonPressed(_ sender: UIButton) {
        if !FileManager.default.fileExists(atPath: ControllerKeys.vocabularyPath.path) {
            let alert = UIAlertController(title: "Error occurred", message: "File does not exist.")
            self.present(alert, animated: true, completion: nil)
            print("File at path \(ControllerKeys.vocabularyPath) does not exist")
            return
        }
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["algashev@mail.ru"])
            composeVC.setSubject("Voca-Voca App Vocabulary")
            composeVC.setMessageBody("Your Vocabulary is in an attachment.", isHTML: false)
            do {
                let attachmentData = try Data(contentsOf: ControllerKeys.vocabularyPath)
                composeVC.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: ControllerKeys.vocabularyFile)
            } catch {
                print("Failed to attach file")
                print("\(error)")
            }
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error occurred", message: "Mail services are not available.")
            self.present(alert, animated: true, completion: nil)
            print("Mail services are not available")
        }
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
        do {
            try FileManager.default.removeItem(at: ControllerKeys.vocabularyPath)
            print("\"\(ControllerKeys.vocabularyFile)\" successfully deleted.")
        } catch {
            print("Failed to delete file")
            print("\(error)")
        }
    }
}

