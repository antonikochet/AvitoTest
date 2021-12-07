//
//  ViewController.swift
//  AvitoTest
//
//  Created by Антон Кочетков on 05.12.2021.
//

import UIKit

class CompanyCollectionViewController: UICollectionViewController {
    
    private var parseModel: ParseModel?
    
    private var sortedEmployees: [Employee]?
    
    private var orientationDevice: UIDeviceOrientation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        view.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EmployeeCell.nib(), forCellWithReuseIdentifier: EmployeeCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkService.fetchData { [weak self] result in
            guard let storageSelf = self else { return }
            switch result {
                case .success(let pm):
                    storageSelf.parseModel = pm
                    storageSelf.sortedEmployees = pm.company.employees.sorted(by: { $0.name < $1.name })
                    DispatchQueue.main.async {
                        storageSelf.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        } completion: { _ in
        }

    }
    
    override func updateViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        super.updateViewConstraints()
    }
    
    @objc private func rotated() {
        if UIDevice.current.orientation != .unknown {
            orientationDevice = UIDevice.current.orientation
        }
    }
}

//MARK: - UICollectionViewDataSource
extension CompanyCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedEmployees?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeeCell.identifier, for: indexPath) as! EmployeeCell
        
        if let employee = sortedEmployees?[indexPath.row] {
            let skills = employee.skills.joined(separator: ", ")
            cell.configure(name: employee.name, phone: employee.phoneNumber, skills: skills)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        header.configure(label: parseModel?.company.name ?? "")
        return header
    }
    
}

extension CompanyCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orientationDevice!.isLandscape {
            let itemsPerRow: CGFloat = 2
            let paddingWidth = 5 * (itemsPerRow + 1)
            let availableWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width - paddingWidth
            let widthFerRow = availableWidth / itemsPerRow
            return CGSize(width: widthFerRow, height: collectionView.frame.height/2)
        } else {
            return CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width, height: collectionView.frame.height/5)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.safeAreaLayoutGuide.layoutFrame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
