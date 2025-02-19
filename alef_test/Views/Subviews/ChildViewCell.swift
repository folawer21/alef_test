import UIKit

final class ChildView: UIView {
    
    // MARK: Internal properties
    
    var onDelete: (() -> Void)?
    
    // MARK: Internal funcs
    
    func clear() {
        nameInput.clear()
        ageInput.clear()
    }
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private properties
    
    private let nameInput = InputFieldView(title: Strings.nameInputText)
    private let ageInput = InputFieldView(title: Strings.ageInputText)
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.deleteChildButtonText, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // MARK: Private funcs
  
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameInput, ageInput])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [stackView, deleteButton])
        mainStack.axis = .horizontal
        mainStack.spacing = 8
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
}
