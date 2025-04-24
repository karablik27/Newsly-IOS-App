import UIKit

private enum Constants {
    static let lightColor: UIColor = UIColor(white: 0.85, alpha: 1.0)
    static let darkColor: UIColor  = UIColor(white: 0.75, alpha: 1.0)

    static let startPoint = CGPoint(x: 0.0, y: 0.5)
    static let endPoint   = CGPoint(x: 1.0, y: 0.5)

    static let locations: [NSNumber] = [0.0, 0.5, 1.0]
    static let animationKey = "shimmer.animation"
    static let animationDuration: CFTimeInterval = 1.5
    static let animationRepeatCount: Float = .infinity

    static let fromValue: [NSNumber] = [-1.0, -0.5, 0.0]
    static let toValue:   [NSNumber] = [1.0, 1.5, 2.0]
}

extension UIView {
    private static let shimmerLayerName = "shimmerLayer"

    func startShimmering() {
        guard layer.sublayers?.first(where: { $0.name == UIView.shimmerLayerName }) == nil else { return }

        let gradient = CAGradientLayer()
        gradient.name = UIView.shimmerLayerName
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius
        gradient.startPoint = Constants.startPoint
        gradient.endPoint   = Constants.endPoint
        gradient.colors     = [Constants.darkColor.cgColor,
                               Constants.lightColor.cgColor,
                               Constants.darkColor.cgColor]
        gradient.locations  = Constants.locations

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = Constants.fromValue
        animation.toValue   = Constants.toValue
        animation.duration  = Constants.animationDuration
        animation.repeatCount = Constants.animationRepeatCount

        gradient.add(animation, forKey: Constants.animationKey)
        layer.addSublayer(gradient)
    }

    func stopShimmering() {
        layer.sublayers?
            .filter { $0.name == UIView.shimmerLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
}
