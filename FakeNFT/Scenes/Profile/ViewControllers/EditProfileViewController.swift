//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Григорий Машук on 10.02.24.
//

import UIKit

protocol EditProfileVCDelegate: AnyObject {
}
 
final class EditProfileViewController: UIViewController {
    private enum ConstansEditVC: String {
        static let editButtonSize = CGSize(width: 42, height: 42)
        static let editImageViewSize = CGSize(width: 70, height: 70)
        static let editImageViewAlphaComponent = CGFloat(0.6)
        static let spacingStackView = CGFloat(22)
        static let textViewLineSpacing = CGFloat(5)
        static let textFieldCornerRadius = CGFloat(12)
        static let paddingTextView = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 0)
        static let editLabelNumberOfLines = 2
        static let numberOfTapsRequired = 1
        case close
    }
    
    weak var delegate: EditProfileVCDelegate?
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton(frame: CGRect(origin: .zero,
                                                size: ConstansEditVC.editButtonSize))
        
        return exitButton
    }()
    
    private lazy var userImageView: UserImageView = {
        let userImageView = UserImageView(image: nil)
        let userImageModel = UserImageModel(url: nil)
        userImageView.config(with: userImageModel)
        
        return userImageView
    }()
    
    private lazy var userImageEditLabelView: UILabel = {
        let userImageEditLabelView = UILabel(frame: CGRect(origin: .zero,
                                                      size: ConstansEditVC.editImageViewSize))
        userImageEditLabelView.text = ConstLocalizable.editUserImage
        userImageEditLabelView.numberOfLines = ConstansEditVC.editLabelNumberOfLines
        userImageEditLabelView.textAlignment = .center
        userImageEditLabelView.textColor = .whiteUniversal
        userImageEditLabelView.font = .headline6
        userImageEditLabelView.frame = userImageView.frame
        
        return userImageEditLabelView
    }()
    
    private lazy var editLoadImageLabel: UILabel = {
        let editLoadImageLabel = UILabel()
        editLoadImageLabel.backgroundColor = .clear
        editLoadImageLabel.textColor = .blackUniversal
        editLoadImageLabel.translatesAutoresizingMaskIntoConstraints = false
        editLoadImageLabel.font = .bodyRegular
        editLoadImageLabel.text = ConstLocalizable.editVCLoadImage
        editLoadImageLabel.textAlignment = .center
        
        return editLoadImageLabel
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = ConstansEditVC.spacingStackView
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.backgroundColor = .clear
        
        return verticalStackView
    }()
    
    private lazy var nameLabelView: UILabel = {
        let nameLabelView = UILabel()
        nameLabelView.backgroundColor = .clear
        nameLabelView.text = ConstLocalizable.editName
        
        return nameLabelView
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        
        return nameTextField
    }()
    
    private lazy var descriptionLabelView: UILabel = {
        let descriptionLabelView = UILabel()
        descriptionLabelView.backgroundColor = .clear
        descriptionLabelView.text = ConstLocalizable.editDescription
        
        return descriptionLabelView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.setPadding(insets: ConstansEditVC.paddingTextView)
        descriptionTextView.resignFirstResponder()
        descriptionTextView.textAlignment = .left
        descriptionTextView.layer.cornerRadius = ConstansEditVC.textFieldCornerRadius
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layoutManager.delegate = self
        descriptionTextView.font = .bodyRegular
        descriptionTextView.textColor = .blackUniversal
        descriptionTextView.backgroundColor = .segmentInactive
        descriptionTextView.text = "Thanks for your help! There was extra space on the end of the string (which in my case was causing a horizontal centering issue), but I fixed it by changing the range to NSMakeRange(0, text.characters.count - 1"
        
        return descriptionTextView
    }()
    
    private lazy var linkLabelView: UILabel = {
        let linkLabelView = UILabel()
        linkLabelView.backgroundColor = .clear
        linkLabelView.text = ConstLocalizable.editLink
        
        return linkLabelView
    }()
    
    private lazy var linkTextField: UITextField = {
        let linkTextField = UITextField()
        
        return linkTextField
    }()
    
    init(delegate: EditProfileVCDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteUniversal
        setupUIItem()
    }
}

private extension EditProfileViewController {
    //MARK: - Setup UIItem
    func setupUIItem() {
        setupExitButton()
        setupUserImageView()
        setupuserImageEditLabelView()
        setupEditLoadImageLabel()
        setupStackView()
        setupTextField()
    }
    
    func setupExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .clear
        exitButton.tintColor = .blackUniversal
        exitButton.setImage(UIImage(named: ConstansEditVC.close.rawValue),
                            for: .normal)
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupUserImageView() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .clear
        view.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 22),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        setupUserImageTap()
    }
    
    func setupuserImageEditLabelView() {
        userImageView.addSubview(userImageEditLabelView)
        userImageEditLabelView.backgroundColor =
            .blackUniversal.withAlphaComponent(ConstansEditVC.editImageViewAlphaComponent)
    }
    
    func setupEditLoadImageLabel() {
        view.addSubview(editLoadImageLabel)
        NSLayoutConstraint.activate([
            editLoadImageLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 15),
            editLoadImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTextField() {
        nameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 132).isActive = true
        linkTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupStackView() {
        view.addSubview(verticalStackView)
        [nameLabelView,
         nameTextField,
         descriptionLabelView,
         descriptionTextView,
         linkLabelView,
         linkTextField].forEach {
            verticalStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [nameTextField, linkTextField].forEach {
            $0.layer.cornerRadius = ConstansEditVC.textFieldCornerRadius
            $0.layer.masksToBounds = true
            $0.textColor = .blackUniversal
            $0.backgroundColor = .segmentInactive
        }

        [nameLabelView,
         descriptionLabelView,
         linkLabelView].forEach {
            $0.font = .headline3
            $0.textColor = .blackUniversal
            $0.textAlignment = .left
        }
        
        let customSpacing = CGFloat(13)
        verticalStackView.setCustomSpacing(customSpacing, after: nameLabelView)
        verticalStackView.setCustomSpacing(customSpacing, after: descriptionLabelView)
        verticalStackView.setCustomSpacing(customSpacing, after: linkLabelView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: editLoadImageLabel.bottomAnchor, constant: -14),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - function
    func setupUserImageTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.userImageTapped(_:)))
        labelTap.numberOfTapsRequired = ConstansEditVC.numberOfTapsRequired
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(labelTap)
    }
    
    @objc
    func userImageTapped(_ sender: UITapGestureRecognizer) {
    }
    
    func displayProfile(model: ProfileUIModel) {
        userImageView.config(with: UserImageModel(url: model.url))
        nameLabelView.text = model.name
        descriptionTextView.text = model.description
        linkLabelView.text = model.link
    }
}

extension EditProfileViewController: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        ConstansEditVC.textViewLineSpacing
    }
}

extension EditProfileViewController: ProfileVCDelegate {
    func setDataUI(model: ProfileUIModel) {
        displayProfile(model: model)
    }
}
