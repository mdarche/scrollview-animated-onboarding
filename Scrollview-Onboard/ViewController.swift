//
//  ViewController.swift
//  Scrollview-Onboard
//
//  Created by Mike Darche on 11/13/16.
//  Copyright © 2016 Mike Darche. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onboardLabel: UILabel!
    
    var imageViews = [UIImageView]()
    let colorView = UIView()
    
    let images = [UIImage(named: "login1"), UIImage(named: "login2"), UIImage(named: "login1")]
    let strings = ["Description text 1", "Description text 2", "Description text 3"]
    
    
    // MARK: - View's lifecycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }
    
    
    // MARK: - Configure scrollView for scrolling animation
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func visualize() {
        onboardLabel.text = strings[0]
        scrollView.delegate = self
        
        scrollView.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width + 3), height: self.view.frame.height)
        var frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let scrollViewHeight = self.scrollView.frame.height
        let scrollViewWidth = self.scrollView.frame.width
        scrollView.contentSize = CGSize(width: (scrollViewWidth * 3), height: scrollViewHeight)
        pageControl.addTarget(self, action: #selector(ViewController.changePage(sender:)), for: .valueChanged)
        
        for index in 0..<3 {
            
            frame.origin.x = scrollViewWidth * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
            
            let subView = UIImageView(frame: frame)
            subView.contentMode = .scaleAspectFill
            subView.layer.masksToBounds = true
            subView.image = images[index]
            self.scrollView.addSubview(subView)
        }
        
        colorView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width*3, height: scrollView.frame.height)
        colorView.alpha = 0.4
        colorView.backgroundColor = .magenta
        self.scrollView.addSubview(colorView)
    }
    
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}


extension ViewController: UIScrollViewDelegate {
    
    
    // MARK: - Handle scroll events
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Vertical
        let maximumVerticalOffset = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset = scrollView.contentOffset.y
        // Horizontal
        let maximumHorizontalOffset = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset = scrollView.contentOffset.x
        // Percentages
        let percentageHorizontalOffset = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset = currentVerticalOffset / maximumVerticalOffset
        
        scrollViewdidScrollToPercentageOffset(scrollView: scrollView, percentageOffset: CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset))
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        switch pageControl.currentPage {
        case 0:
            onboardLabel.text = strings[0]
        case 1:
            onboardLabel.text = strings[1]
        case 2:
            onboardLabel.text = strings[2]
        default:
            print("Default")
        }
    }
    
    
    func scrollViewdidScrollToPercentageOffset(scrollView: UIScrollView, percentageOffset: CGPoint) {
        var colors : [UIColor] = [.magenta, .blue, .red]
        
        if (percentageOffset.x < 0.5) {
            colorView.backgroundColor = fadeFromColor(fromColor: colors[0], toColor: colors[1], withPercentage: percentageOffset.x*2)
        } else {
            colorView.backgroundColor = fadeFromColor(fromColor: colors[1], toColor: colors[2], withPercentage: (percentageOffset.x - 0.5)*2)
        }
    }
    

    // MARK: - Calculate current color for animation
    
    
    func fadeFromColor(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        
        var fromRed: CGFloat = 0.0, fromGreen: CGFloat = 0.0, fromBlue: CGFloat = 0.0, fromAlpha: CGFloat = 0.0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0, toGreen: CGFloat = 0.0, toBlue: CGFloat = 0.0, toAlpha: CGFloat = 0.0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = (toRed - fromRed) * withPercentage + fromRed
        let green = (toGreen - fromGreen) * withPercentage + fromGreen
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

