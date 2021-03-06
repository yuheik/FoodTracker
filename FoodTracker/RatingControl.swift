//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Yuhei Kikuchi on 2018/01/04.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }

    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }

    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        LogUtil.traceFunc()

        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        LogUtil.traceFunc()

        setupButtons()
    }


    //MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        LogUtil.traceFunc()

        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button \(button), is not in the ratingButtons array \(ratingButtons)")
        }

        // Calculate the rating of the selected button
        let selectedRating = index + 1

        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }


    //MARK: Private Methods
    private func setupButtons() {
        LogUtil.traceFunc()

        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()

        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar      = UIImage(named: "filledStar",      in: bundle, compatibleWith: self.traitCollection)
        let emptyStar       = UIImage(named: "emptyStar",       in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        for index in 0..<starCount {
            // Create the button
            let button = UIButton()

            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])

            // Add Constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            // Set the accessiblity label
            button.accessibilityLabel = "Set \(index + 1) star rating"

            // Setup the button action
            button.addTarget(self,
                             action: #selector(RatingControl.ratingButtonTapped(button:)),
                             for: .touchUpInside)

            // Add the button to the stack
            addArrangedSubview(button)

            // Add the new button to the rating button array
            ratingButtons.append(button)
        }

        updateButtonSelectionStates()
    }

    private func updateButtonSelectionStates() {
        LogUtil.traceFunc()

        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, the button should be selected.
            button.isSelected = (index < rating)

            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }

            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }

            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
