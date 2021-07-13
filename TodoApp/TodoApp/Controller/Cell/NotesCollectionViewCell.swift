//
//  NotesCollectionViewCell.swift
//  TodoApp
//
//  Created by Satyam Kumar on 08/07/21.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesDate: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesContent: UILabel!

    @IBOutlet weak var delButton: UIButton!
}
