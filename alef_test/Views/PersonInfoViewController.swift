import UIKit

final class PersonInfoViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let scrollView = UIScrollView()
    private let stackView = {
        let stackView =  UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let contentView = UIView()
    private let personalLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.screenName
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let nameInput = InputFieldView(title: Strings.nameInputText)
    private let ageInput = InputFieldView(title: Strings.ageInputText)
    
    private let childrenLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.childrenTableHeader
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let addChildButton: UIButton = {
        let button = UIButton(type: .system)
        
        if let plusImage = UIImage(systemName: Strings.plusImage) {
            button.setImage(plusImage, for: .normal)
        }
        
        button.setTitle(Strings.addChildButtonText, for: .normal)
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
        
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    private let childrenStackView = UIStackView()
    private let childrenHeaderStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.clearButtonText, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 30,
            bottom: 10,
            right: 30
        )
        return button
    }()
    
    private var childrenArray: [ChildView] = []
    
    // MARK: Internal funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        addChildButton.addTarget(self, action: #selector(addChildInfo), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(showClearConfirmation), for: .touchUpInside)
    }
    
    // MARK: Private funcs
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        setupStackView()
        
        contentView.addSubview(stackView)
        contentView.addSubview(clearButton)
        childrenStackView.axis = .vertical
        childrenStackView.spacing = 10
        setupContsraints()
    }
    
    private func setupStackView() {
        childrenHeaderStackView.addArrangedSubview(childrenLabel)
        childrenHeaderStackView.addArrangedSubview(addChildButton)
        let views = [
            personalLabel,
            nameInput,
            ageInput,
            childrenHeaderStackView,
            childrenStackView
        ]
        views.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupContsraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -20),
    
            
            clearButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            clearButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalToConstant: 200),
            clearButton.heightAnchor.constraint(equalToConstant: 45),
            clearButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    @objc private func addChildInfo() {
        guard childrenArray.count < 5 else { return }
        
        let childView = ChildView()
        childView.onDelete = { [weak self, weak childView] in
            guard let self = self, let childView = childView else { return }
            self.childrenArray.removeAll { $0 == childView }
            self.childrenStackView.removeArrangedSubview(childView)
            childView.removeFromSuperview()
            self.updateAddChildButtonVisibility()
        }
        
        childrenArray.append(childView)
        childrenStackView.addArrangedSubview(childView)
        
        updateAddChildButtonVisibility()
    }
    
    private func updateAddChildButtonVisibility() {
        addChildButton.isHidden = childrenArray.count >= 5
    }
    
    @objc private func showClearConfirmation() {
        let actionSheet = UIAlertController(title: Strings.clearAlertText , message: nil, preferredStyle: .actionSheet)
        
        let resetAction = UIAlertAction(title: Strings.clearAlertButton, style: .destructive) { _ in
            self.clearAll()
        }
        
        let cancelAction = UIAlertAction(title: Strings.cancelAlertButton, style: .cancel)
        
        actionSheet.addAction(resetAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func clearAll() {
        nameInput.clear()
        ageInput.clear()
        
        childrenArray.forEach { $0.removeFromSuperview() }
        childrenArray.removeAll()
        childrenStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        updateAddChildButtonVisibility()
    }
}
