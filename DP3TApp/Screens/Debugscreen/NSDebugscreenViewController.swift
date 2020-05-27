/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

#if ENABLE_TESTING

    import UIKit

    class NSDebugscreenViewController: NSViewController {
        // MARK: - Views

        private let stackScrollView = NSStackScrollView()

        private let imageView = UIImageView(image: UIImage(named: "03-privacy"))

        private let mockModuleView = NSDebugScreenMockView()
        private let sdkStatusView = NSDebugScreenSDKStatusView()
        private let certificatePinningButton = NSButton(title: "", style: .uppercase(.ns_purple))
        private let certificatePinningView = NSSimpleModuleBaseView(title: "")
        private let logsView = NSSimpleModuleBaseView(title: "Logs", text: "")

        // MARK: - Init

        override init() {
            super.init()
            title = "debug_settings_title".ub_localized
        }

        // MARK: - View

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .ns_backgroundSecondary
            setup()
            certificatePinningView.contentView.addArrangedView(certificatePinningButton)
            certificatePinningButton.addTarget(self, action: #selector(toggleCertificatePinning), for: .touchUpInside)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: true)
            updateLogs()
            updateCertificatePinningView()
        }

        private func updateLogs() {
            logsView.textLabel.attributedText = UIStateManager.shared.uiState.debug.logOutput
        }

        // MARK: - Setup

        private func setup() {
            // stack scrollview
            view.addSubview(stackScrollView)
            stackScrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            stackScrollView.stackView.isLayoutMarginsRelativeArrangement = true
            stackScrollView.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

            stackScrollView.addSpacerView(NSPadding.large)

            // image view
            let v = UIView()
            v.addSubview(imageView)

            imageView.contentMode = .scaleAspectFit

            imageView.snp.makeConstraints { make in
                make.centerX.top.bottom.equalToSuperview()
                make.height.equalTo(170)
            }

            stackScrollView.addArrangedView(v)

            stackScrollView.addSpacerView(NSPadding.large)

            stackScrollView.addArrangedView(sdkStatusView)

            stackScrollView.addSpacerView(NSPadding.large)

            stackScrollView.addArrangedView(mockModuleView)

            stackScrollView.addSpacerView(NSPadding.large)

            stackScrollView.addArrangedView(certificatePinningView)

            stackScrollView.addSpacerView(NSPadding.large)

            stackScrollView.addArrangedView(logsView)

            stackScrollView.addSpacerView(NSPadding.large)
        }

        @objc
        private func toggleCertificatePinning() {
            URLSession.evaluator.useCertificatePinning.toggle()
            updateCertificatePinningView()
        }

        private func updateCertificatePinningView() {
            if URLSession.evaluator.useCertificatePinning {
                certificatePinningView.title = "certificate-pinning.title".ub_localized + "🔒"
                certificatePinningButton.setTitle("certificate-pinning.button.disable".ub_localized, for: .normal)
            } else {
                certificatePinningView.title = "certificate-pinning.title".ub_localized + "🔓"
                certificatePinningButton.setTitle("certificate-pinning.button.enable".ub_localized, for: .normal)
            }
        }
    }

#endif
