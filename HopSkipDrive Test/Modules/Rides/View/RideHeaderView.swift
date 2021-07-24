//
//  RideHeaderView.swift
//  HopSkipDrive Test
//
//  Created by Benjamin VanCleave on 7/21/21.
//

import UIKit

class RideHeaderView: UIView {
    var rides: [Ride]! {
        didSet {
            setupView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupTimeDateLabel()
        setupEstimatedTotalLabel()
    }
    
    /* FUNCTION TO SETUP ESTIMATED TOTAL PRICE LABEL BY COMBING TRIP PRICES
     FOR THAT GIVEN DAY AND THEN CONVERTING CENTS TO DOLLARS */
    private func setupEstimatedTotalLabel() {
        let total = rides.map({$0.estimatedEarningCents ?? 0}).reduce(0, +).convertToDollarString()
        let mutableString = NSMutableAttributedString(string: "ESTIMATED\n\(total)")
        let range = NSRange(location: 0, length: 9)
        mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .light), range: range)
        mutableString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        estimated.attributedText = mutableString
    }
    
    /* FUNCTION THAT CALCULATES THE DAYS TOTAL TIME BY TAKING THE START TIME
     OF THE EARLIEST RIDE AND THE END TIME FOR THE LAST RIDE */
    private func setupTimeDateLabel() {
        if let firstRide = rides.first, let lastRide = rides.last {
            dateLabel.text = firstRide.startsAt?.dateFromIso(format: "E MM/dd")
            if let startTime = firstRide.startsAt?.timeFromIso(),
               let endTime = lastRide.endsAt?.timeFromIso() {
                let mutableString = NSMutableAttributedString(string: "  •  \(startTime) - \(endTime)")
                let range = NSRange(location: 0, length: 5 + startTime.count)
                mutableString.addAttribute(.font,
                                           value: UIFont.systemFont(ofSize: timeLabel.font.pointSize,
                                                                    weight: .bold),
                                           range: range)
                timeLabel.attributedText = mutableString
            }
        }
    }
    
    /* FUNCTION TO CREATE THE VIEW AND ADD THE CONSTRAINTS, DEMONSTRATING
     CREATING VIEWS PROGRAMMATICALLY VERSUS INTERFACE */
    private func createView() {
        backgroundColor = .systemBackground
        addSubview(dateLabel)
        addSubview(timeLabel)
        addSubview(estimated)
        addSubview(bottomLine)
        addConstraints([
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            timeLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 0),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            estimated.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            estimated.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
            bottomLine.widthAnchor.constraint(equalToConstant: frame.width)
        ])
    }
    
    // MARK: - VIEW PROPERTIES
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Thu 6/17"
        label.textColor = UIColor(red: 8/255, green: 51/255, blue: 100/255, alpha: 1)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "  •  4:18a - 4:26p"
        label.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let lineOne = UIView()
        view.addSubview(lineOne)
        lineOne.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        lineOne.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        let lineTwo = UIView()
        view.addSubview(lineTwo)
        lineTwo.frame = CGRect(x: 0, y: 1, width: UIScreen.main.bounds.width, height: 1)
        lineTwo.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            
        return view
    }()
    
    let estimated: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "ESTIMATED\n105.25"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(red: 25/255, green: 65/255, blue: 110/255, alpha: 1)
            //UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        return label
    }()
}
