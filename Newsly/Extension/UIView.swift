import UIKit

extension UIView {
    private static let shimmerLayerName = "shimmerLayer"

    /// Запускает shimmer-эффект на вьюшке
    func startShimmering() {
        // Если уже есть слой — не добавляем повторно
        guard layer.sublayers?.first(where: { $0.name == UIView.shimmerLayerName }) == nil else { return }

        let light = UIColor(white: 0.85, alpha: 1.0).cgColor
        let dark  = UIColor(white: 0.75, alpha: 1.0).cgColor

        let gradient = CAGradientLayer()
        gradient.name = UIView.shimmerLayerName
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)
        gradient.colors     = [dark, light, dark]
        gradient.locations  = [0.0, 0.5, 1.0]

        // Анимация движения градиента
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue   = [1.0, 1.5, 2.0]
        animation.duration  = 1.5
        animation.repeatCount = .infinity

        gradient.add(animation, forKey: "shimmer.animation")
        layer.addSublayer(gradient)
    }

    /// Останавливает shimmer-эффект
    func stopShimmering() {
        layer.sublayers?
            .filter { $0.name == UIView.shimmerLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
}
