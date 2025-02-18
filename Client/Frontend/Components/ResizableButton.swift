// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

class ResizableButton: UIButton {

    struct UX {
        static let buttonEdgeSpacing: CGFloat = 8
    }

    var buttonEdgeSpacing: CGFloat = UX.buttonEdgeSpacing {
        didSet {
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: buttonEdgeSpacing,
                                             bottom: 0,
                                             right: buttonEdgeSpacing)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        titleLabel?.numberOfLines = 0
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.lineBreakMode = .byWordWrapping
        contentEdgeInsets = UIEdgeInsets(top: 0,
                                         left: buttonEdgeSpacing,
                                         bottom: 0,
                                         right: buttonEdgeSpacing)
    }

    override var intrinsicContentSize: CGSize {
        guard let title = titleLabel else {
            return super.intrinsicContentSize
        }
        let size = title.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude))
        return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right, height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let title = titleLabel else { return }

        titleLabel?.preferredMaxLayoutWidth = title.frame.size.width
    }
}
