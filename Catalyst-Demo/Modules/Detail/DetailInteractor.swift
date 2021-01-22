//
//  DetailInteractor.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//  
//

// sourcery: AutoMockable
protocol DetailInteractorInput: AnyObject {
}

// sourcery: AutoMockable
protocol DetailInteractorOutput: AnyObject {
}

final class DetailInteractor {

    weak var output: DetailInteractorOutput?
}

// MARK: - DetailInteractorInput

extension DetailInteractor: DetailInteractorInput {
}
