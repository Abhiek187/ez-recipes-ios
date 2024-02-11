//
//  CaseIterableExtension.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 2/11/24.
//

extension CaseIterable where Self: Equatable {
    /// Go to the previous case in an enum
    /// - Returns: the previous enum value, or the start index if at the beginning
    func previous() -> Self {
        let all = Self.allCases
        guard let currentIndex = all.firstIndex(of: self) else { return self }
        let previousIndex = all.index(currentIndex, offsetBy: -1)
        return all[previousIndex < all.startIndex ? all.startIndex : previousIndex]
    }
    
    /// Go to the next case in an enum
    /// - Returns: the next enum value, or the end index if at the end
    func next() -> Self {
        let all = Self.allCases
        guard let currentIndex = all.firstIndex(of: self) else { return self }
        let nextIndex = all.index(after: currentIndex)
        return all[nextIndex == all.endIndex ? currentIndex : nextIndex]
    }
    
    /// Returns `true` if the enum is the first case
    var isFirst: Bool {
        self.previous() == self
    }
    
    /// Returns `true` if the enum is the last case
    var isLast: Bool {
        self.next() == self
    }
}
